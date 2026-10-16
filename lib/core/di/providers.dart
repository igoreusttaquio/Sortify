import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/activity/data/activity_repository_impl.dart';
import '../../features/activity/domain/activity_repository.dart';
import '../../features/folders/data/folder_repository_impl.dart';
import '../../features/folders/domain/folder_repository.dart';
import '../../features/rules/data/rule_repository_impl.dart';
import '../../features/rules/domain/rule_repository.dart';
import '../../features/settings/data/settings_store.dart';
import '../database/app_database.dart';
import '../filesystem/file_deleter.dart';
import '../filesystem/local_file_system.dart';

/// Single database instance for the app. Tests can override this provider.
final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase.instance);

final localFileSystemProvider = Provider<LocalFileSystem>(
  (ref) => const LocalFileSystem(),
);

final fileDeleterProvider = Provider<FileDeleter>(
  (ref) => const FileDeleter(),
);

final folderRepositoryProvider = Provider<FolderRepository>(
  (ref) => FolderRepositoryImpl(ref.watch(appDatabaseProvider)),
);

final ruleRepositoryProvider = Provider<RuleRepository>(
  (ref) => RuleRepositoryImpl(ref.watch(appDatabaseProvider)),
);

final activityRepositoryProvider = Provider<ActivityRepository>(
  (ref) => ActivityRepositoryImpl(ref.watch(appDatabaseProvider)),
);

/// Overridden in `main()` with an initialized instance.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider not overridden'),
);

final settingsStoreProvider = Provider<SettingsStore>(
  (ref) => SettingsStore(ref.watch(sharedPreferencesProvider)),
);
