import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../core/filesystem/file_deleter.dart';
import '../../../core/filesystem/file_utils.dart';
import '../../../core/filesystem/local_file_system.dart';
import '../../activity/domain/activity_repository.dart';
import '../../activity/domain/file_operation.dart';
import '../domain/rule.dart';
import '../domain/rule_action.dart';
import '../domain/rule_condition.dart';
import '../domain/rule_enums.dart';

/// Outcome of evaluating and executing rules for one file.
class EngineResult {
  const EngineResult({required this.matched, required this.operation});

  final bool matched;
  final FileOperation? operation;
}

/// Evaluates rules against files and executes the resulting move.
///
/// The engine is intentionally free of UI and provider concerns so it can be
/// unit tested in isolation.
class RuleEngine {
  RuleEngine({
    required LocalFileSystem fileSystem,
    required ActivityRepository activityRepository,
    required FileDeleter fileDeleter,
    Uuid? uuid,
  }) : _fs = fileSystem,
       _activity = activityRepository,
       _deleter = fileDeleter,
       _uuid = uuid ?? const Uuid();

  final LocalFileSystem _fs;
  final ActivityRepository _activity;
  final FileDeleter _deleter;
  final Uuid _uuid;

  /// Returns the first enabled rule whose conditions all match [file].
  Rule? firstMatch({
    required File file,
    required List<Rule> rules,
    required bool ignoreHidden,
    required String folderPath,
  }) {
    if (ignoreHidden && p.basename(file.path).startsWith('.')) return null;
    for (final rule in rules) {
      if (!rule.enabled) continue;
      if (!rule.isActionReady) continue;
      if (!_appliesToFolder(rule, folderPath)) continue;
      if (_matches(rule, file)) return rule;
    }
    return null;
  }

  bool _appliesToFolder(Rule rule, String folderPath) {
    final scope = rule.scopeFolderPath;
    if (scope == null) return true;
    return p.equals(scope, folderPath);
  }

  /// Whether [path]'s extension is in the user's ignore list.
  static bool isIgnoredExtension(String path, Set<String> ignoredExtensions) {
    if (ignoredExtensions.isEmpty) return false;
    final extension = p.extension(path).replaceFirst('.', '').toLowerCase();
    return extension.isNotEmpty && ignoredExtensions.contains(extension);
  }

  bool _matches(Rule rule, File file) {
    if (rule.conditions.isEmpty) return false;
    for (final condition in rule.conditions) {
      if (!_matchesCondition(condition, file)) return false;
    }
    return true;
  }

  bool _matchesCondition(RuleCondition condition, File file) {
    switch (condition.type) {
      case ConditionType.extension:
        return _matchesExtension(condition, file.path);
      case ConditionType.size:
        return _matchesSize(condition, file.lengthSync());
      case ConditionType.name:
        return _matchesName(condition, FileUtils.fileNameOf(file.path));
    }
  }

  bool _matchesExtension(RuleCondition condition, String path) {
    final extension = FileUtils.extensionOf(path);
    final candidates = condition.value
        .split(',')
        .map((v) => v.trim().toLowerCase())
        .where((v) => v.isNotEmpty)
        .map((v) => v.startsWith('.') ? v : '.$v')
        .toSet();
    final contains = candidates.contains(extension);
    return condition.operator == ConditionOperator.isNot ? !contains : contains;
  }

  bool _matchesSize(RuleCondition condition, int bytes) {
    final target = FileUtils.parseSize(condition.value);
    if (target == null) return false;
    return switch (condition.operator) {
      ConditionOperator.greaterThan => bytes > target,
      ConditionOperator.lessThan => bytes < target,
      ConditionOperator.isNot => bytes != target,
      ConditionOperator.equalTo => bytes == target,
      _ => bytes == target,
    };
  }

  bool _matchesName(RuleCondition condition, String name) {
    final value = condition.value.toLowerCase();
    final haystack = name.toLowerCase();
    return switch (condition.operator) {
      ConditionOperator.contains => haystack.contains(value),
      ConditionOperator.doesNotContain => !haystack.contains(value),
      ConditionOperator.isNot => haystack != value,
      _ => haystack == value,
    };
  }

  /// Executes the first matching rule for [file].
  ///
  /// When [dryRun] is true no filesystem change happens; the returned operation
  /// describes what *would* occur.
  Future<EngineResult> processFile({
    required File file,
    required String watchedFolderPath,
    required List<Rule> rules,
    required bool ignoreHidden,
    required bool deleteToTrash,
    bool dryRun = false,
  }) async {
    final rule = firstMatch(
      file: file,
      rules: rules,
      ignoreHidden: ignoreHidden,
      folderPath: watchedFolderPath,
    );

    if (rule == null) {
      return const EngineResult(matched: false, operation: null);
    }

    final action = rule.primaryAction!;
    final behavior = _behaviorOf(rule.conflictPolicy);
    final plannedDestination = _plannedDestination(
      action: action,
      file: file,
      watchedFolderPath: watchedFolderPath,
    );

    if (dryRun) {
      return EngineResult(
        matched: true,
        operation: FileOperation(
          id: _uuid.v4(),
          ruleId: rule.id,
          ruleName: rule.name,
          fileName: FileUtils.fileNameOf(file.path),
          source: file.path,
          destination: plannedDestination,
          operation: _kindOf(action),
          status: OperationStatus.moved,
          createdAt: DateTime.now(),
        ),
      );
    }

    final MoveResult result;
    switch (action.type) {
      case ActionType.move:
        result = await _fs.moveFile(
          source: file.path,
          destination: plannedDestination!,
          behavior: behavior,
        );
      case ActionType.copy:
        result = await _fs.copyFile(
          source: file.path,
          destination: plannedDestination!,
          behavior: behavior,
        );
      case ActionType.rename:
        result = await _fs.renameFile(source: file.path, newName: action.value);
      case ActionType.delete:
        final deleted = await _deleter.delete(
          file.path,
          toTrash: deleteToTrash,
        );
        result = deleted.success
            ? MoveResult.moved(file.path)
            : MoveResult.failed(deleted.error ?? 'Delete failed');
    }

    final operation = FileOperation(
      id: _uuid.v4(),
      ruleId: rule.id,
      ruleName: rule.name,
      fileName: FileUtils.fileNameOf(file.path),
      source: file.path,
      destination: action.type == ActionType.delete
          ? null
          : (result.destination ?? plannedDestination),
      operation: _kindOf(action),
      status: switch (result.status) {
        MoveStatus.moved => OperationStatus.moved,
        MoveStatus.skipped => OperationStatus.skipped,
        MoveStatus.failed => OperationStatus.failed,
      },
      error: result.error,
      createdAt: DateTime.now(),
    );

    await _activity.insert(operation);
    return EngineResult(matched: true, operation: operation);
  }

  /// Lists files in [folderPath] that match [rule] without moving anything.
  Future<List<File>> previewMatches({
    required Rule rule,
    required String folderPath,
    required bool recursive,
    required bool ignoreHidden,
    Set<String> ignoredExtensions = const {},
  }) async {
    if (!_appliesToFolder(rule, folderPath)) return const [];
    final dir = Directory(folderPath);
    if (!await dir.exists()) return const [];
    final files = <File>[];
    await for (final entity in dir.list(
      recursive: recursive,
      followLinks: false,
    )) {
      if (entity is! File) continue;
      if (ignoreHidden && p.basename(entity.path).startsWith('.')) continue;
      if (isIgnoredExtension(entity.path, ignoredExtensions)) continue;
      if (rule.conditions.isEmpty) continue;
      if (_matches(rule, entity)) files.add(entity);
    }
    return files;
  }

  String? _plannedDestination({
    required RuleAction action,
    required File file,
    required String watchedFolderPath,
  }) {
    switch (action.type) {
      case ActionType.move:
      case ActionType.copy:
        // The action value is a destination *folder*; the file keeps its name.
        final folder = FileUtils.resolveDestination(
          watchedFolder: watchedFolderPath,
          destination: action.value,
        );
        return p.join(folder, p.basename(file.path));
      case ActionType.rename:
        var name = action.value.trim();
        if (name.isEmpty) return null;
        if (p.extension(name).isEmpty) {
          name = '$name${p.extension(file.path)}';
        }
        return p.join(p.dirname(file.path), name);
      case ActionType.delete:
        return null;
    }
  }

  OperationKind _kindOf(RuleAction action) => switch (action.type) {
    ActionType.move => OperationKind.move,
    ActionType.copy => OperationKind.copy,
    ActionType.rename => OperationKind.rename,
    ActionType.delete => OperationKind.delete,
  };

  ConflictBehavior _behaviorOf(ConflictPolicy policy) => switch (policy) {
    ConflictPolicy.askEveryTime => ConflictBehavior.keepBoth,
    ConflictPolicy.keepBoth => ConflictBehavior.keepBoth,
    ConflictPolicy.replace => ConflictBehavior.replace,
    ConflictPolicy.skip => ConflictBehavior.skip,
  };
}
