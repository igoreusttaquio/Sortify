import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../domain/file_operation.dart';

/// Loads the activity log, newest first.
class ActivityController extends AsyncNotifier<List<FileOperation>> {
  @override
  Future<List<FileOperation>> build() {
    return ref.watch(activityRepositoryProvider).getRecent(limit: 300);
  }

  Future<void> clear() async {
    await ref.read(activityRepositoryProvider).clear();
    ref.invalidateSelf();
    await future;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final activityControllerProvider =
    AsyncNotifierProvider<ActivityController, List<FileOperation>>(
      ActivityController.new,
    );

/// Currently selected activity filter, `null` means "All".
class ActivityFilterController extends Notifier<OperationStatus?> {
  @override
  OperationStatus? build() => null;

  void set(OperationStatus? status) => state = status;
}

final activityFilterProvider =
    NotifierProvider<ActivityFilterController, OperationStatus?>(
      ActivityFilterController.new,
    );

/// Count of files moved since midnight, used by the dashboard.
final movedTodayProvider = FutureProvider<int>((ref) async {
  // Recompute whenever the activity log changes.
  ref.watch(activityControllerProvider);
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  return ref.watch(activityRepositoryProvider).countMovedSince(startOfDay);
});
