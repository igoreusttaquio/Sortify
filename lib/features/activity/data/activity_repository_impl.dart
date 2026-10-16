import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../core/database/app_database.dart';
import '../domain/activity_repository.dart';
import '../domain/file_operation.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl(this._db);

  final AppDatabase _db;

  static const _table = 'file_operations';

  @override
  Future<List<FileOperation>> getRecent({
    int limit = 100,
    OperationStatus? status,
  }) async {
    final database = await _db.database;
    final rows = await database.query(
      _table,
      where: status == null ? null : 'status = ?',
      whereArgs: status == null ? null : [status.dbValue],
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return rows.map(_fromRow).toList();
  }

  @override
  Future<void> insert(FileOperation operation) async {
    final database = await _db.database;
    await database.insert(
      _table,
      _toRow(operation),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> countMovedSince(DateTime since) async {
    final database = await _db.database;
    final result = await database.rawQuery(
      'SELECT COUNT(*) AS c FROM $_table '
      'WHERE status = ? AND operation = ? AND created_at >= ?',
      [
        OperationStatus.moved.dbValue,
        OperationKind.move.dbValue,
        since.millisecondsSinceEpoch,
      ],
    );
    return (result.first['c'] as int?) ?? 0;
  }

  @override
  Future<void> clear() async {
    final database = await _db.database;
    await database.delete(_table);
  }

  FileOperation _fromRow(Map<String, Object?> row) {
    return FileOperation(
      id: row['id']! as String,
      ruleId: row['rule_id'] as String?,
      ruleName: row['rule_name'] as String?,
      fileName: row['file_name']! as String,
      source: row['source']! as String,
      destination: row['destination'] as String?,
      operation: OperationKind.fromDb(row['operation']! as String),
      status: OperationStatus.fromDb(row['status']! as String),
      error: row['error'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at']! as int),
    );
  }

  Map<String, Object?> _toRow(FileOperation operation) {
    return {
      'id': operation.id,
      'rule_id': operation.ruleId,
      'rule_name': operation.ruleName,
      'file_name': operation.fileName,
      'source': operation.source,
      'destination': operation.destination,
      'operation': operation.operation.dbValue,
      'status': operation.status.dbValue,
      'error': operation.error,
      'created_at': operation.createdAt.millisecondsSinceEpoch,
    };
  }
}
