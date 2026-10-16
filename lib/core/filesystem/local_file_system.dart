import 'dart:io';

import 'package:path/path.dart' as p;

import 'file_utils.dart';

/// Runtime conflict strategy. Mirrors the rule-level [ConflictPolicy] but lives
/// in the core layer so the filesystem code stays feature agnostic.
enum ConflictBehavior {
  /// Cannot be answered automatically; the engine resolves this to [keepBoth]
  /// when running in the background and asks the user for manual runs.
  askEveryTime,
  keepBoth,
  replace,
  skip,
}

enum MoveStatus { moved, skipped, failed }

class MoveResult {
  const MoveResult({required this.status, this.destination, this.error});

  final MoveStatus status;
  final String? destination;
  final String? error;

  factory MoveResult.moved(String destination) =>
      MoveResult(status: MoveStatus.moved, destination: destination);

  factory MoveResult.skipped(String reason) =>
      MoveResult(status: MoveStatus.skipped, error: reason);

  factory MoveResult.failed(String error) =>
      MoveResult(status: MoveStatus.failed, error: error);
}

/// Thin, well-tested wrapper over `dart:io` for the operations Sortify performs.
class LocalFileSystem {
  const LocalFileSystem();

  Future<MoveResult> moveFile({
    required String source,
    required String destination,
    required ConflictBehavior behavior,
  }) async {
    final sourceFile = File(source);
    if (!await sourceFile.exists()) {
      return MoveResult.failed('Source file no longer exists');
    }

    var target = destination;
    final targetFile = File(target);

    if (await targetFile.exists()) {
      switch (behavior) {
        case ConflictBehavior.skip:
          return MoveResult.skipped('Destination already exists');
        case ConflictBehavior.replace:
          await targetFile.delete();
        case ConflictBehavior.keepBoth:
        case ConflictBehavior.askEveryTime:
          target = FileUtils.uniquePath(target);
      }
    }

    try {
      await Directory(p.dirname(target)).create(recursive: true);
      await _move(sourceFile, File(target));
      return MoveResult.moved(target);
    } on FileSystemException catch (error) {
      return MoveResult.failed(_describe(error));
    } on IOException catch (error) {
      return MoveResult.failed(error.toString());
    }
  }

  /// Whether [path] looks like a finished file: it exists, is not locked by
  /// another process and its size is stable. Used to avoid touching files that
  /// are still being written (e.g. a large copy in progress).
  Future<bool> isFileReady(String path) async {
    final file = File(path);
    if (!await file.exists()) return false;

    final int firstLength;
    try {
      firstLength = await file.length();
    } on FileSystemException {
      return false;
    }

    // A file that can be opened for writing is not locked by another process.
    if (!await isFileUnlocked(path)) return false;

    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!await file.exists()) return false;
    try {
      return await file.length() == firstLength;
    } on FileSystemException {
      return false;
    }
  }

  /// Fast check: whether the file can be opened for writing (i.e. no other
  /// process holds an exclusive lock on it).
  Future<bool> isFileUnlocked(String path) async {
    try {
      final handle = await File(path).open(mode: FileMode.append);
      await handle.close();
      return true;
    } catch (_) {
      return false;
    }
  }

  String _describe(FileSystemException error) {
    final osError = error.osError;
    if (osError != null) {
      return '${error.message} (${osError.errorCode}: ${osError.message})';
    }
    return error.message;
  }

  Future<MoveResult> copyFile({
    required String source,
    required String destination,
    required ConflictBehavior behavior,
  }) async {
    final sourceFile = File(source);
    if (!await sourceFile.exists()) {
      return MoveResult.failed('Source file no longer exists');
    }

    var target = destination;
    final targetFile = File(target);
    if (await targetFile.exists()) {
      switch (behavior) {
        case ConflictBehavior.skip:
          return MoveResult.skipped('Destination already exists');
        case ConflictBehavior.replace:
          await targetFile.delete();
        case ConflictBehavior.keepBoth:
        case ConflictBehavior.askEveryTime:
          target = FileUtils.uniquePath(target);
      }
    }

    try {
      await Directory(p.dirname(target)).create(recursive: true);
      await sourceFile.copy(target);
      return MoveResult.moved(target);
    } on FileSystemException catch (error) {
      return MoveResult.failed(_describe(error));
    } on IOException catch (error) {
      return MoveResult.failed(error.toString());
    }
  }

  Future<MoveResult> renameFile({
    required String source,
    required String newName,
  }) async {
    final sourceFile = File(source);
    if (!await sourceFile.exists()) {
      return MoveResult.failed('Source file no longer exists');
    }

    var name = newName.trim();
    if (name.isEmpty) return MoveResult.failed('Name cannot be empty');
    if (p.extension(name).isEmpty) {
      name = '$name${p.extension(source)}';
    }

    final target = p.normalize(p.join(p.dirname(source), name));
    if (p.equals(target, source)) {
      return MoveResult.skipped('Name unchanged');
    }
    if (await File(target).exists()) {
      return MoveResult.failed('A file with that name already exists');
    }

    try {
      await _move(sourceFile, File(target));
      return MoveResult.moved(target);
    } on FileSystemException catch (error) {
      return MoveResult.failed(_describe(error));
    } on IOException catch (error) {
      return MoveResult.failed(error.toString());
    }
  }

  /// Renames when possible, falling back to copy+delete across volumes.
  Future<void> _move(File source, File target) async {
    try {
      await source.rename(target.path);
    } on FileSystemException {
      await source.copy(target.path);
      await source.delete();
    }
  }

  Future<bool> exists(String path) => File(path).exists();

  Future<void> revealInFileManager(String path) async {
    if (Platform.isWindows) {
      await Process.run('explorer', [path]);
    } else if (Platform.isMacOS) {
      await Process.run('open', ['-R', path]);
    } else {
      await Process.run('xdg-open', [p.dirname(path)]);
    }
  }
}
