import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../core/database/app_database.dart';
import '../domain/folder_repository.dart';
import '../domain/watched_folder.dart';

class FolderRepositoryImpl implements FolderRepository {
  FolderRepositoryImpl(this._db);

  final AppDatabase _db;

  static const _table = 'watched_folders';

  @override
  Future<List<WatchedFolder>> getAll() async {
    final database = await _db.database;
    final rows = await database.query(
      _table,
      orderBy: 'created_at ASC',
    );
    return rows.map(_fromRow).toList();
  }

  @override
  Future<void> upsert(WatchedFolder folder) async {
    final database = await _db.database;
    await database.insert(
      _table,
      _toRow(folder),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> remove(String id) async {
    final database = await _db.database;
    await database.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> setEnabled(String id, bool enabled) async {
    final database = await _db.database;
    await database.update(
      _table,
      {'enabled': enabled ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  WatchedFolder _fromRow(Map<String, Object?> row) {
    return WatchedFolder(
      id: row['id']! as String,
      path: row['path']! as String,
      enabled: (row['enabled'] as int? ?? 1) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at']! as int),
    );
  }

  Map<String, Object?> _toRow(WatchedFolder folder) {
    return {
      'id': folder.id,
      'path': folder.path,
      'enabled': folder.enabled ? 1 : 0,
      'created_at': folder.createdAt.millisecondsSinceEpoch,
    };
  }
}
