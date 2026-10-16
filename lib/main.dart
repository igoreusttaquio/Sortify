import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/di/providers.dart';
import 'core/system/app_paths.dart';
import 'features/settings/data/settings_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppDatabase.initializeFfi();

  final preferences = await SharedPreferences.getInstance();
  final settings = SettingsStore(preferences).load();

  await windowManager.ensureInitialized();
  final windowOptions = WindowOptions(
    size: const Size(1320, 840),
    minimumSize: const Size(1024, 680),
    center: true,
    title: 'Sortify',
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    // Windows/macOS take the icon from the bundled resources; the runtime call
    // is mainly for Linux and is safe to ignore elsewhere.
    try {
      await windowManager.setIcon(
        AppPaths.assetPath('assets/images/app_icon.png'),
      );
    } catch (_) {
      // Ignored: platform does not support setting the window icon at runtime.
    }

    if (settings.startMinimized) {
      await windowManager.hide();
    } else {
      await windowManager.show();
      await windowManager.focus();
    }
  });

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const SortifyApp(),
    ),
  );
}
