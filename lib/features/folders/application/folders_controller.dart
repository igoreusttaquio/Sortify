import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../core/di/providers.dart';
import '../domain/watched_folder.dart';

/// Loads and mutates the list of watched folders.
class FoldersController extends AsyncNotifier<List<WatchedFolder>> {
  static const _uuid = Uuid();

  @override
  Future<List<WatchedFolder>> build() {
    return ref.watch(folderRepositoryProvider).getAll();
  }

  Future<bool> addPath(String path) async {
    final existing = state.value ?? const <WatchedFolder>[];
    final normalized = p.normalize(path);
    final duplicate = existing.any(
      (f) => p.equals(f.path, normalized),
    );
    if (duplicate) return false;

    await ref.read(folderRepositoryProvider).upsert(
      WatchedFolder(
        id: _uuid.v4(),
        path: normalized,
        createdAt: DateTime.now(),
      ),
    );
    await _reload();
    return true;
  }

  Future<void> remove(String id) async {
    await ref.read(folderRepositoryProvider).remove(id);
    await _reload();
  }

  Future<void> setEnabled(String id, bool enabled) async {
    await ref.read(folderRepositoryProvider).setEnabled(id, enabled);
    await _reload();
  }

  Future<void> _reload() async {
    ref.invalidateSelf();
    await future;
  }
}

final foldersControllerProvider =
    AsyncNotifierProvider<FoldersController, List<WatchedFolder>>(
      FoldersController.new,
    );
