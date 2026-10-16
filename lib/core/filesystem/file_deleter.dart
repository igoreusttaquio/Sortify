import 'dart:io';

import 'package:path/path.dart' as p;

import 'file_utils.dart';

class DeleteResult {
  const DeleteResult({
    required this.success,
    this.usedTrash = false,
    this.error,
  });

  final bool success;
  final bool usedTrash;
  final String? error;
}

/// Deletes files either permanently or, when asked and supported, by moving
/// them to the operating system trash/recycle bin. Falls back to permanent
/// deletion if the trash is unavailable.
class FileDeleter {
  const FileDeleter();

  Future<DeleteResult> delete(String path, {required bool toTrash}) async {
    final file = File(path);
    if (!await file.exists()) {
      return const DeleteResult(success: false, error: 'File no longer exists');
    }

    if (toTrash && await _tryTrash(file)) {
      return const DeleteResult(success: true, usedTrash: true);
    }

    try {
      await file.delete();
      return const DeleteResult(success: true);
    } on FileSystemException catch (error) {
      return DeleteResult(success: false, error: error.message);
    } on IOException catch (error) {
      return DeleteResult(success: false, error: error.toString());
    }
  }

  Future<bool> _tryTrash(File file) async {
    try {
      if (Platform.isWindows) return await _trashWindows(file);
      if (Platform.isMacOS) return await _trashMacOs(file);
      if (Platform.isLinux) return await _trashLinux(file);
    } catch (_) {
      return false;
    }
    return false;
  }

  Future<bool> _trashMacOs(File file) async {
    final home = Platform.environment['HOME'];
    if (home == null) return false;
    final trash = Directory(p.join(home, '.Trash'));
    if (!await trash.exists()) return false;
    final target = FileUtils.uniquePath(
      p.join(trash.path, p.basename(file.path)),
    );
    await file.rename(target);
    return true;
  }

  Future<bool> _trashLinux(File file) async {
    final home = Platform.environment['HOME'];
    if (home == null) return false;
    final base = p.join(home, '.local', 'share', 'Trash');
    final filesDir = Directory(p.join(base, 'files'));
    final infoDir = Directory(p.join(base, 'info'));
    await filesDir.create(recursive: true);
    await infoDir.create(recursive: true);

    final target = FileUtils.uniquePath(
      p.join(filesDir.path, p.basename(file.path)),
    );
    final targetName = p.basename(target);
    await file.rename(target);
    await File(p.join(infoDir.path, '$targetName.trashinfo')).writeAsString(
      '[Trash Info]\n'
      'Path=${file.path}\n'
      'DeletionDate=${DateTime.now().toIso8601String()}\n',
    );
    return true;
  }

  Future<bool> _trashWindows(File file) async {
    final escaped = file.path.replaceAll("'", "''");
    final script =
        'Add-Type -AssemblyName Microsoft.VisualBasic; '
        "[Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile("
        "'$escaped','OnlyErrorDialogs','SendToRecycleBin')";
    final result = await Process.run('powershell', [
      '-NoProfile',
      '-NonInteractive',
      '-Command',
      script,
    ]);
    return result.exitCode == 0;
  }
}
