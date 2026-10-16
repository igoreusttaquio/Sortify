import 'file_operation.dart';

/// Persistence boundary for the activity log.
abstract interface class ActivityRepository {
  Future<List<FileOperation>> getRecent({
    int limit = 100,
    OperationStatus? status,
  });

  Future<void> insert(FileOperation operation);

  Future<int> countMovedSince(DateTime since);

  Future<void> clear();
}
