import 'watched_folder.dart';

/// Persistence boundary for watched folders.
abstract interface class FolderRepository {
  Future<List<WatchedFolder>> getAll();

  Future<void> upsert(WatchedFolder folder);

  Future<void> remove(String id);

  Future<void> setEnabled(String id, bool enabled);
}
