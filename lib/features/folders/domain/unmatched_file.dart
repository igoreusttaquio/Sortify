import 'package:path/path.dart' as p;

/// A file that currently has no matching rule.
class UnmatchedFile {
  const UnmatchedFile({required this.path, required this.folderPath});

  final String path;
  final String folderPath;

  String get fileName => p.basename(path);

  String get extension => p.extension(path).replaceFirst('.', '').toLowerCase();

  /// Name of the folder this file currently lives in.
  String get folderName => p.basename(folderPath);

  @override
  bool operator ==(Object other) =>
      other is UnmatchedFile && other.path == path;

  @override
  int get hashCode => path.hashCode;
}
