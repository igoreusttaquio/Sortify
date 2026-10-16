import 'dart:io';

import 'package:path/path.dart' as p;

/// Resolves the per-user application support directory without relying on
/// plugins, so the data layer stays buildable on every desktop platform.
abstract final class AppPaths {
  static const _appFolder = 'Sortify';

  static String get _home {
    final env = Platform.environment;
    return env['HOME'] ?? env['USERPROFILE'] ?? Directory.current.path;
  }

  /// Where the SQLite database and other app data live.
  static String get supportDirectory {
    if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA'];
      if (appData != null && appData.isNotEmpty) {
        return p.join(appData, _appFolder);
      }
      return p.join(_home, 'AppData', 'Roaming', _appFolder);
    }

    if (Platform.isMacOS) {
      return p.join(_home, 'Library', 'Application Support', _appFolder);
    }

    final xdg = Platform.environment['XDG_DATA_HOME'];
    if (xdg != null && xdg.isNotEmpty) {
      return p.join(xdg, _appFolder.toLowerCase());
    }
    return p.join(_home, '.local', 'share', _appFolder.toLowerCase());
  }

  static Future<void> ensureSupportDirectory() async {
    final dir = Directory(supportDirectory);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  /// Absolute path of a bundled Flutter asset (e.g. the window/tray icon).
  /// Mirrors where the tool lays assets next to the executable.
  static String assetPath(String assetKey) {
    final executable = Platform.resolvedExecutable;
    if (Platform.isMacOS) {
      return p.joinAll([
        p.dirname(p.dirname(executable)),
        'Frameworks',
        'App.framework',
        'Resources',
        'flutter_assets',
        ...assetKey.split('/'),
      ]);
    }
    return p.joinAll([
      p.dirname(executable),
      'data',
      'flutter_assets',
      ...assetKey.split('/'),
    ]);
  }
}
