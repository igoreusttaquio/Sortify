import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:watcher/watcher.dart';

import '../../../core/di/providers.dart';
import '../../../core/filesystem/file_utils.dart';
import '../../../core/notifications/notification_controller.dart';
import '../../activity/application/activity_controller.dart';
import '../../activity/domain/file_operation.dart';
import '../../rules/application/rule_engine.dart';
import '../../rules/application/rules_controller.dart';
import '../../rules/application/rule_preview.dart';
import '../../rules/domain/rule.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../domain/unmatched_file.dart';
import '../domain/watched_folder.dart';
import 'folders_controller.dart';

class MonitoringState {
  const MonitoringState({
    this.running = true,
    this.unmatched = const <UnmatchedFile>[],
    this.lastScanAt,
    this.busy = false,
  });

  final bool running;
  final List<UnmatchedFile> unmatched;
  final DateTime? lastScanAt;
  final bool busy;

  MonitoringState copyWith({
    bool? running,
    List<UnmatchedFile>? unmatched,
    DateTime? lastScanAt,
    bool? busy,
  }) {
    return MonitoringState(
      running: running ?? this.running,
      unmatched: unmatched ?? this.unmatched,
      lastScanAt: lastScanAt ?? this.lastScanAt,
      busy: busy ?? this.busy,
    );
  }
}

/// Watches folders, evaluates rules and executes moves in the background.
class MonitoringController extends Notifier<MonitoringState> {
  static const _uuid = Uuid();

  final Map<String, StreamSubscription<WatchEvent>> _subscriptions = {};
  final Map<String, Timer> _debounce = {};
  final Map<String, DateTime> _ignoreUntil = {};
  final Set<String> _processing = {};

  DateTime _watchersReadyAt = DateTime.now();

  RuleEngine get _engine => RuleEngine(
    fileSystem: ref.read(localFileSystemProvider),
    activityRepository: ref.read(activityRepositoryProvider),
    fileDeleter: ref.read(fileDeleterProvider),
  );

  /// Polls until [path] is no longer being written, so large copies are only
  /// moved once they are complete. Gives up after ~2 minutes.
  Future<bool> _waitUntilReady(String path) async {
    for (var attempt = 0; attempt < 240; attempt++) {
      if (!File(path).existsSync()) return false;
      if (await ref.read(localFileSystemProvider).isFileReady(path)) {
        return true;
      }
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    return File(path).existsSync();
  }

  @override
  MonitoringState build() {
    ref.onDispose(() {
      _cancelAll();
    });

    ref.listen(foldersControllerProvider, (previous, next) {
      final folders = next.value;
      if (folders == null) return;
      _syncWatchers(folders);
      if (state.running) unawaited(refreshUnmatched());
    });

    ref.listen(rulesControllerProvider, (previous, next) {
      if (next.value == null) return;
      if (state.running) unawaited(refreshUnmatched());
    });

    // Settings that affect which files are tracked re-evaluate immediately,
    // without needing to pause/resume monitoring.
    ref.listen(settingsControllerProvider, (previous, next) {
      if (previous == null || previous == next) return;
      final relevant =
          !const ListEquality<String>().equals(
            previous.ignoredExtensions,
            next.ignoredExtensions,
          ) ||
          previous.ignoreHiddenFiles != next.ignoreHiddenFiles ||
          previous.watchSubfolders != next.watchSubfolders;
      if (!relevant || !state.running) return;
      unawaited(refreshUnmatched());
    });

    // Deferred to the event loop so no provider is mutated while widgets build.
    Future<void>(_bootstrap);
    return const MonitoringState();
  }

  Future<void> _bootstrap() async {
    final folders =
        ref.read(foldersControllerProvider).value ?? const <WatchedFolder>[];
    _syncWatchers(folders);
    await refreshUnmatched();
  }

  void _syncWatchers(List<WatchedFolder> folders) {
    _cancelAll();
    if (!state.running) return;

    _watchersReadyAt = DateTime.now().add(const Duration(seconds: 2));

    for (final folder in folders.where((f) => f.enabled)) {
      if (!Directory(folder.path).existsSync()) continue;
      try {
        final watcher = DirectoryWatcher(folder.path);
        _subscriptions[folder.id] = watcher.events.listen(
          (event) => _onEvent(event, folder),
          onError: (_) {},
        );
      } on FileSystemException {
        // Folder is not watchable; skip quietly.
      }
    }
  }

  void _cancelAll() {
    for (final sub in _subscriptions.values) {
      sub.cancel();
    }
    _subscriptions.clear();
    for (final timer in _debounce.values) {
      timer.cancel();
    }
    _debounce.clear();
  }

  void _onEvent(WatchEvent event, WatchedFolder folder) {
    if (event.type == ChangeType.REMOVE) return;
    if (DateTime.now().isBefore(_watchersReadyAt)) return;

    final path = event.path;
    if (_isIgnored(path)) return;

    final settings = ref.read(settingsControllerProvider);
    if (settings.ignoreHiddenFiles && p.basename(path).startsWith('.')) return;
    if (RuleEngine.isIgnoredExtension(
      path,
      settings.ignoredExtensions.toSet(),
    )) {
      return;
    }

    _debounce[path]?.cancel();
    _debounce[path] = Timer(
      const Duration(milliseconds: 700),
      () => _processIncoming(path, folder),
    );
  }

  bool _isIgnored(String path) {
    final until = _ignoreUntil[path];
    if (until == null) return false;
    if (DateTime.now().isAfter(until)) {
      _ignoreUntil.remove(path);
      return false;
    }
    return true;
  }

  Future<void> _processIncoming(String path, WatchedFolder folder) async {
    if (_processing.contains(path)) return;
    if (!File(path).existsSync()) return;
    if (!FileSystemEntity.isFileSync(path)) return;

    _processing.add(path);
    try {
      // Wait until the file stops being written before touching it. Large
      // copies take longer than the watcher debounce.
      if (!await _waitUntilReady(path)) return;

      final settings = ref.read(settingsControllerProvider);
      final rules = ref.read(rulesControllerProvider).value ?? const <Rule>[];

      final result = await _engine.processFile(
        file: File(path),
        watchedFolderPath: folder.path,
        rules: rules,
        ignoreHidden: settings.ignoreHiddenFiles,
        deleteToTrash: settings.deleteBehavior == DeleteBehavior.trash,
      );

      if (!result.matched) {
        await _recordUnmatched(path, folder.path);
      } else {
        final destination = result.operation?.destination;
        if (destination != null) {
          _ignoreUntil[destination] = DateTime.now().add(
            const Duration(seconds: 5),
          );
        }
        _removeUnmatched(path);
        _refreshDerived();
      }
    } finally {
      _processing.remove(path);
    }
  }

  Future<void> _recordUnmatched(String path, String folderPath) async {
    state = state.copyWith(
      unmatched: _mergeUnmatched(state.unmatched, path, folderPath),
    );

    final operation = FileOperation(
      id: _uuid.v4(),
      fileName: p.basename(path),
      source: path,
      operation: OperationKind.move,
      status: OperationStatus.skipped,
      error: 'No matching rule',
      createdAt: DateTime.now(),
    );
    await ref.read(activityRepositoryProvider).insert(operation);
    _refreshActivity();
  }

  void _removeUnmatched(String path) {
    final next = state.unmatched.where((f) => f.path != path).toList();
    if (next.length != state.unmatched.length) {
      state = state.copyWith(unmatched: next);
    }
  }

  List<UnmatchedFile> _mergeUnmatched(
    List<UnmatchedFile> current,
    String path,
    String folderPath,
  ) {
    if (current.any((f) => f.path == path)) return current;
    return [...current, UnmatchedFile(path: path, folderPath: folderPath)];
  }

  /// Re-scans watched folders and refreshes the unmatched list. Does not move
  /// any files.
  Future<void> refreshUnmatched() async {
    final folders =
        (ref.read(foldersControllerProvider).value ?? const <WatchedFolder>[])
            .where((f) => f.enabled)
            .toList();
    if (folders.isEmpty) {
      state = state.copyWith(unmatched: const [], lastScanAt: DateTime.now());
      return;
    }

    final settings = ref.read(settingsControllerProvider);
    final rules = ref.read(rulesControllerProvider).value ?? const <Rule>[];
    final ignored = settings.ignoredExtensions.toSet();
    final unmatched = <UnmatchedFile>[];

    for (final folder in folders) {
      final dir = Directory(folder.path);
      if (!await dir.exists()) continue;
      try {
        await for (final entity in dir.list(
          recursive: settings.watchSubfolders,
          followLinks: false,
        )) {
          if (entity is! File) continue;
          if (settings.ignoreHiddenFiles &&
              p.basename(entity.path).startsWith('.')) {
            continue;
          }
          if (RuleEngine.isIgnoredExtension(entity.path, ignored)) continue;
          final match = _engine.firstMatch(
            file: entity,
            rules: rules,
            ignoreHidden: settings.ignoreHiddenFiles,
            folderPath: folder.path,
          );
          if (match == null) {
            unmatched.add(
              UnmatchedFile(path: entity.path, folderPath: folder.path),
            );
          }
        }
      } on FileSystemException {
        // Ignore folders that disappear mid-scan.
      }
    }

    state = state.copyWith(unmatched: unmatched, lastScanAt: DateTime.now());
  }

  /// Runs every enabled rule across all watched folders.
  Future<int> runAll() async {
    state = state.copyWith(busy: true);
    try {
      return await _run(rules: null);
    } finally {
      state = state.copyWith(busy: false);
    }
  }

  /// Applies a single rule regardless of its enabled flag (the builder's
  /// "Apply rule" action).
  Future<int> applyRule(Rule rule) async {
    state = state.copyWith(busy: true);
    try {
      return await _run(rules: [rule.copyWith(enabled: true)]);
    } finally {
      state = state.copyWith(busy: false);
    }
  }

  Future<int> _run({required List<Rule>? rules}) async {
    final folders =
        (ref.read(foldersControllerProvider).value ?? const <WatchedFolder>[])
            .where((f) => f.enabled)
            .toList();
    if (folders.isEmpty) return 0;

    final settings = ref.read(settingsControllerProvider);
    final activeRules =
        rules ?? ref.read(rulesControllerProvider).value ?? const <Rule>[];

    var moved = 0;
    var failed = 0;
    String? firstError;

    for (final folder in folders) {
      final dir = Directory(folder.path);
      if (!await dir.exists()) continue;
      try {
        await for (final entity in dir.list(
          recursive: settings.watchSubfolders,
          followLinks: false,
        )) {
          if (entity is! File) continue;
          if (settings.ignoreHiddenFiles &&
              p.basename(entity.path).startsWith('.')) {
            continue;
          }
          if (RuleEngine.isIgnoredExtension(
            entity.path,
            settings.ignoredExtensions.toSet(),
          )) {
            continue;
          }
          if (_processing.contains(entity.path)) continue;
          // Skip files that are still being written (e.g. a large copy).
          if (!await ref
              .read(localFileSystemProvider)
              .isFileUnlocked(entity.path)) {
            continue;
          }
          _processing.add(entity.path);
          try {
            final result = await _engine.processFile(
              file: entity,
              watchedFolderPath: folder.path,
              rules: activeRules,
              ignoreHidden: settings.ignoreHiddenFiles,
              deleteToTrash: settings.deleteBehavior == DeleteBehavior.trash,
            );
            if (result.matched &&
                result.operation?.status == OperationStatus.moved) {
              moved++;
              final destination = result.operation?.destination;
              if (destination != null) {
                _ignoreUntil[destination] = DateTime.now().add(
                  const Duration(seconds: 5),
                );
              }
            } else if (result.matched &&
                result.operation?.status == OperationStatus.failed) {
              failed++;
              firstError ??= result.operation?.error;
            }
          } finally {
            _processing.remove(entity.path);
          }
        }
      } on FileSystemException {
        // Folder vanished during the run.
      }
    }

    await refreshUnmatched();
    _refreshDerived();

    if (failed > 0) {
      ref
          .read(notificationProvider.notifier)
          .error(firstError ?? 'Failed to organize $failed file(s)');
    }
    return moved;
  }

  /// The files a rule would affect, without changing anything.
  Future<List<RulePreviewEntry>> previewRule(Rule rule) async {
    final folders =
        (ref.read(foldersControllerProvider).value ?? const <WatchedFolder>[])
            .where((f) => f.enabled)
            .toList();
    final settings = ref.read(settingsControllerProvider);
    final entries = <RulePreviewEntry>[];

    for (final folder in folders) {
      final files = await _engine.previewMatches(
        rule: rule,
        folderPath: folder.path,
        recursive: settings.watchSubfolders,
        ignoreHidden: settings.ignoreHiddenFiles,
        ignoredExtensions: settings.ignoredExtensions.toSet(),
      );
      for (final file in files) {
        final destination = rule.destination == null
            ? ''
            : FileUtils.resolveDestination(
                watchedFolder: folder.path,
                destination: rule.destination!,
              );
        entries.add(
          RulePreviewEntry(
            sourcePath: file.path,
            sourceFolder: folder.path,
            destination: destination,
          ),
        );
      }
    }
    return entries;
  }

  /// Stops the watchers and starts them again, so newly added folders are
  /// picked up immediately, and resumes monitoring.
  void restart() {
    final folders =
        ref.read(foldersControllerProvider).value ?? const <WatchedFolder>[];
    _cancelAll();
    state = state.copyWith(running: true);
    _syncWatchers(folders);
    unawaited(refreshUnmatched());
  }

  void pause() {
    _cancelAll();
    state = state.copyWith(running: false);
  }

  void resume() {
    state = state.copyWith(running: true);
    final folders =
        ref.read(foldersControllerProvider).value ?? const <WatchedFolder>[];
    _syncWatchers(folders);
    unawaited(refreshUnmatched());
  }

  void toggle() => state.running ? pause() : resume();

  void _refreshActivity() {
    ref.invalidate(activityControllerProvider);
    ref.invalidate(movedTodayProvider);
  }

  void _refreshDerived() {
    _refreshActivity();
    ref.invalidate(rulesControllerProvider);
  }
}

final monitoringControllerProvider =
    NotifierProvider<MonitoringController, MonitoringState>(
      MonitoringController.new,
    );

/// Convenience selector for the dashboard.
final unmatchedProvider = Provider<List<UnmatchedFile>>(
  (ref) => ref.watch(monitoringControllerProvider).unmatched,
);
