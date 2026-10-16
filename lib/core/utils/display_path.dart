import 'dart:io';

import 'package:path/path.dart' as p;

/// Formats absolute paths for display, collapsing the home directory to `~`.
abstract final class DisplayPath {
  static String? get _home {
    final env = Platform.environment;
    return env['HOME'] ?? env['USERPROFILE'];
  }

  static String shorten(String path) {
    final home = _home;
    if (home == null || home.isEmpty) return path;
    if (p.equals(path, home)) return '~';
    if (p.isWithin(home, path)) {
      final relative = p.relative(path, from: home);
      return '~${p.separator}$relative';
    }
    return path;
  }

  /// A short label for a file operation, e.g. `Downloads → Documents/PDFs`.
  static String summary(String source, String? destination) {
    final from = p.basename(p.dirname(source));
    if (destination == null || destination.isEmpty) {
      return p.basename(source);
    }
    final to = shorten(destination);
    return '$from  →  $to';
  }
}
