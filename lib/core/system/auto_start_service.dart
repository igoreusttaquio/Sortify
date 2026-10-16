import 'dart:io';

import 'package:path/path.dart' as p;

/// Enables or disables launching Sortify when the user signs in.
///
/// Implemented per-platform without extra plugins:
///  • Windows: HKCU\...\CurrentVersion\Run registry value
///  • macOS:   ~/Library/LaunchAgents plist
///  • Linux:   ~/.config/autostart .desktop entry
class AutoStartService {
  const AutoStartService();

  static const _appName = 'Sortify';
  static const _macLabel = 'com.sortify.app';
  static const _linuxFileName = 'sortify.desktop';

  String get _executablePath => Platform.resolvedExecutable;

  Future<bool> isEnabled() async {
    if (Platform.isWindows) {
      final result = await Process.run('reg', [
        'query',
        r'HKCU\Software\Microsoft\Windows\CurrentVersion\Run',
        '/v',
        _appName,
      ]);
      return result.exitCode == 0;
    }
    final file = await _file();
    return file != null && file.existsSync();
  }

  Future<void> setEnabled(bool enabled) async {
    if (Platform.isWindows) {
      if (enabled) {
        await Process.run('reg', [
          'add',
          r'HKCU\Software\Microsoft\Windows\CurrentVersion\Run',
          '/v',
          _appName,
          '/t',
          'REG_SZ',
          '/d',
          '"$_executablePath"',
          '/f',
        ]);
      } else {
        await Process.run('reg', [
          'delete',
          r'HKCU\Software\Microsoft\Windows\CurrentVersion\Run',
          '/v',
          _appName,
          '/f',
        ]);
      }
      return;
    }

    final file = await _file();
    if (file == null) return;
    if (enabled) {
      await file.parent.create(recursive: true);
      await file.writeAsString(_contents());
    } else if (file.existsSync()) {
      await file.delete();
    }
  }

  Future<File?> _file() async {
    if (Platform.isMacOS) {
      final home = Platform.environment['HOME'];
      if (home == null) return null;
      return File(
        p.join(home, 'Library', 'LaunchAgents', '$_macLabel.plist'),
      );
    }
    if (Platform.isLinux) {
      final home = Platform.environment['HOME'];
      if (home == null) return null;
      return File(p.join(home, '.config', 'autostart', _linuxFileName));
    }
    return null;
  }

  String _contents() {
    if (Platform.isMacOS) {
      return '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$_macLabel</string>
  <key>ProgramArguments</key>
  <array>
    <string>$_executablePath</string>
    <string>--minimized</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
''';
    }
    return '''
[Desktop Entry]
Type=Application
Name=$_appName
Exec=$_executablePath --minimized
X-GNOME-Autostart-enabled=true
''';
  }
}
