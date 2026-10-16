import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../domain/app_settings.dart';

/// Holds the current preferences and persists every change.
class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(settingsStoreProvider).load();

  Future<void> update(
    AppSettings Function(AppSettings current) transform,
  ) async {
    final next = transform(state);
    if (next == state) return;
    state = next;
    await ref.read(settingsStoreProvider).save(next);
  }

  Future<void> setTheme(AppThemePreference theme) =>
      update((s) => s.copyWith(theme: theme));

  Future<void> setLanguage(String code) =>
      update((s) => s.copyWith(languageCode: code));
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);
