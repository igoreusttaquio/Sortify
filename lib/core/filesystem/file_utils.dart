import 'dart:io';

import 'package:path/path.dart' as p;

/// Pure path helpers shared by the rule engine and the UI.
abstract final class FileUtils {
  /// Lowercase extension including the dot, e.g. `.pdf`. Empty when none.
  static String extensionOf(String path) => p.extension(path).toLowerCase();

  /// File name without the directory, e.g. `invoice.pdf`.
  static String fileNameOf(String path) => p.basename(path);

  /// Extension with the leading dot removed, e.g. `pdf`.
  static String extensionLabel(String path) {
    final ext = extensionOf(path);
    return ext.startsWith('.') ? ext.substring(1) : ext;
  }

  /// Resolves a rule destination against the watched folder.
  ///
  /// Absolute destinations are used as-is. Relative destinations resolve
  /// against the watched folder's parent, so a rule watching `~/Downloads`
  /// with destination `Pictures` writes to `~/Pictures`.
  static String resolveDestination({
    required String watchedFolder,
    required String destination,
  }) {
    final trimmed = destination.trim();
    if (p.isAbsolute(trimmed)) return p.normalize(trimmed);
    final parent = p.dirname(watchedFolder);
    return p.normalize(p.join(parent, trimmed));
  }

  /// Returns a non-existing path by appending ` (1)`, ` (2)`, … before the
  /// extension. Used by the "keep both" conflict policy.
  static String uniquePath(String path) {
    final dir = p.dirname(path);
    final ext = p.extension(path);
    final base = p.basenameWithoutExtension(path);
    var candidate = path;
    var counter = 1;
    while (File(candidate).existsSync()) {
      candidate = p.join(dir, '$base ($counter)$ext');
      counter++;
    }
    return candidate;
  }

  /// Human readable size, e.g. `10 MB`, `1.5 GB`.
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    const units = ['KB', 'MB', 'GB', 'TB'];
    var size = bytes / 1024;
    var unit = 0;
    while (size >= 1024 && unit < units.length - 1) {
      size /= 1024;
      unit++;
    }
    final rounded = size >= 10 ? size.toStringAsFixed(0) : size.toStringAsFixed(1);
    return '$rounded ${units[unit]}';
  }

  /// Parses a user supplied size such as `10 MB`, `500kb`, `2g` into bytes.
  static int? parseSize(String value) {
    final match = RegExp(
      r'^\s*([0-9]+(?:[.,][0-9]+)?)\s*(b|kb|mb|gb|tb)?\s*$',
      caseSensitive: false,
    ).firstMatch(value);
    if (match == null) return null;
    final number = double.tryParse(match.group(1)!.replaceAll(',', '.'));
    if (number == null) return null;
    final unit = (match.group(2) ?? 'b').toLowerCase();
    const multipliers = {
      'b': 1,
      'kb': 1024,
      'mb': 1024 * 1024,
      'gb': 1024 * 1024 * 1024,
      'tb': 1024 * 1024 * 1024 * 1024,
    };
    return (number * multipliers[unit]!).round();
  }
}
