import 'package:path/path.dart' as p;

/// Expands `{token}` placeholders in user supplied folder and file names.
///
/// Supported tokens (case-insensitive):
/// - `{name}`  file name without extension
/// - `{ext}`   extension without the dot, lowercase (`pdf`)
/// - `{year}`  four digit year of the file's modification date
/// - `{month}` two digit month
/// - `{day}`   two digit day
/// - `{date}`  `yyyy-MM-dd`
///
/// Unknown tokens are left untouched so typos stay visible to the user.
abstract final class NameTemplate {
  static const tokens = ['name', 'ext', 'year', 'month', 'day', 'date'];

  static final _pattern = RegExp(r'\{(\w+)\}');

  /// Characters Windows rejects in file and folder names. Path separators are
  /// handled separately so templates can describe nested folders.
  static final _invalidChars = RegExp(r'[<>:"|?*\x00-\x1F]');

  static bool hasTokens(String template) => _pattern.hasMatch(template);

  static String render(
    String template, {
    required String filePath,
    required DateTime modified,
  }) {
    String two(int v) => v.toString().padLeft(2, '0');
    final ext = p.extension(filePath).replaceFirst('.', '').toLowerCase();
    final values = <String, String>{
      'name': p.basenameWithoutExtension(filePath),
      'ext': ext.isEmpty ? 'other' : ext,
      'year': modified.year.toString(),
      'month': two(modified.month),
      'day': two(modified.day),
      'date': '${modified.year}-${two(modified.month)}-${two(modified.day)}',
    };
    return template.replaceAllMapped(_pattern, (match) {
      return values[match.group(1)!.toLowerCase()] ?? match.group(0)!;
    });
  }

  /// Renders [template] as a relative folder path: every segment is sanitized
  /// and `.`/`..` segments are dropped so the result can never escape the
  /// destination folder.
  static String renderFolder(
    String template, {
    required String filePath,
    required DateTime modified,
  }) {
    final rendered = render(template, filePath: filePath, modified: modified);
    final segments = rendered
        .split(RegExp(r'[\\/]'))
        .map(sanitizeSegment)
        .where((s) => s.isNotEmpty && s != '.' && s != '..');
    return p.joinAll(segments);
  }

  /// Removes characters that are invalid in a single file or folder name.
  static String sanitizeSegment(String segment) =>
      segment.replaceAll(_invalidChars, '_').trim();
}
