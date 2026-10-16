import 'package:shared_preferences/shared_preferences.dart';

import '../../rules/domain/rule_enums.dart';
import '../domain/app_settings.dart';

/// Reads and writes [AppSettings] to a [SharedPreferences] instance.
class SettingsStore {
  SettingsStore(this._prefs);

  final SharedPreferences _prefs;

  static const _kTheme = 'settings.theme';
  static const _kLanguage = 'settings.language';
  static const _kStartWithSystem = 'settings.startWithSystem';
  static const _kStartMinimized = 'settings.startMinimized';
  static const _kConfirmOps = 'settings.confirmFileOperations';
  static const _kScanInterval = 'settings.scanIntervalSeconds';
  static const _kWatchSubfolders = 'settings.watchSubfolders';
  static const _kIgnoreHidden = 'settings.ignoreHiddenFiles';
  static const _kIgnoredExtensions = 'settings.ignoredExtensions';
  static const _kConflict = 'settings.defaultConflictPolicy';
  static const _kDeleteBehavior = 'settings.deleteBehavior';

  AppSettings load() {
    return const AppSettings().copyWith(
      theme: AppThemePreference.fromDb(
        _prefs.getString(_kTheme) ?? AppThemePreference.dark.dbValue,
      ),
      languageCode: _prefs.getString(_kLanguage) ?? 'en',
      startWithSystem: _prefs.getBool(_kStartWithSystem) ?? false,
      startMinimized: _prefs.getBool(_kStartMinimized) ?? false,
      confirmFileOperations: _prefs.getBool(_kConfirmOps) ?? true,
      scanIntervalSeconds: _prefs.getInt(_kScanInterval) ?? 5,
      watchSubfolders: _prefs.getBool(_kWatchSubfolders) ?? true,
      ignoreHiddenFiles: _prefs.getBool(_kIgnoreHidden) ?? true,
      ignoredExtensions: _prefs.getStringList(_kIgnoredExtensions) ?? const [],
      defaultConflictPolicy: ConflictPolicy.fromDb(
        _prefs.getString(_kConflict) ?? ConflictPolicy.askEveryTime.dbValue,
      ),
      deleteBehavior: DeleteBehavior.fromDb(
        _prefs.getString(_kDeleteBehavior) ?? DeleteBehavior.permanent.dbValue,
      ),
    );
  }

  Future<void> save(AppSettings settings) async {
    await Future.wait([
      _prefs.setString(_kTheme, settings.theme.dbValue),
      _prefs.setString(_kLanguage, settings.languageCode),
      _prefs.setBool(_kStartWithSystem, settings.startWithSystem),
      _prefs.setBool(_kStartMinimized, settings.startMinimized),
      _prefs.setBool(_kConfirmOps, settings.confirmFileOperations),
      _prefs.setInt(_kScanInterval, settings.scanIntervalSeconds),
      _prefs.setBool(_kWatchSubfolders, settings.watchSubfolders),
      _prefs.setBool(_kIgnoreHidden, settings.ignoreHiddenFiles),
      _prefs.setStringList(_kIgnoredExtensions, settings.ignoredExtensions),
      _prefs.setString(_kConflict, settings.defaultConflictPolicy.dbValue),
      _prefs.setString(_kDeleteBehavior, settings.deleteBehavior.dbValue),
    ]);
  }
}
