import 'package:freezed_annotation/freezed_annotation.dart';

import '../../rules/domain/rule_enums.dart';

part 'app_settings.freezed.dart';

enum AppThemePreference {
  system('system'),
  light('light'),
  dark('dark');

  const AppThemePreference(this.dbValue);

  final String dbValue;

  static AppThemePreference fromDb(String value) =>
      AppThemePreference.values.firstWhere(
        (e) => e.dbValue == value,
        orElse: () => AppThemePreference.dark,
      );
}

/// What happens when a user deletes a file through Sortify.
enum DeleteBehavior {
  /// Remove the file from disk immediately.
  permanent('permanent'),

  /// Best-effort move to the OS trash/recycle bin.
  trash('trash');

  const DeleteBehavior(this.dbValue);

  final String dbValue;

  static DeleteBehavior fromDb(String value) =>
      DeleteBehavior.values.firstWhere(
        (e) => e.dbValue == value,
        orElse: () => DeleteBehavior.permanent,
      );
}

/// User preferences. Persisted with `shared_preferences`; intentionally small
/// so nothing here requires SQLite.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(AppThemePreference.dark) AppThemePreference theme,
    @Default('en') String languageCode,
    @Default(false) bool startWithSystem,
    @Default(false) bool startMinimized,
    @Default(true) bool confirmFileOperations,
    @Default(5) int scanIntervalSeconds,
    @Default(true) bool watchSubfolders,
    @Default(true) bool ignoreHiddenFiles,
    @Default(<String>[]) List<String> ignoredExtensions,
    @Default(ConflictPolicy.askEveryTime) ConflictPolicy defaultConflictPolicy,
    @Default(DeleteBehavior.permanent) DeleteBehavior deleteBehavior,
  }) = _AppSettings;
}
