import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../core/database/app_database.dart';
import '../../rules/domain/rule.dart';
import '../domain/rule_action.dart';
import '../domain/rule_condition.dart';
import '../domain/rule_enums.dart';
import '../domain/rule_repository.dart';

class RuleRepositoryImpl implements RuleRepository {
  RuleRepositoryImpl(this._db);

  final AppDatabase _db;

  static const _rules = 'rules';
  static const _conditions = 'conditions';
  static const _actions = 'actions';

  @override
  Future<List<Rule>> getAll() async {
    final database = await _db.database;
    final ruleRows = await database.query(_rules, orderBy: 'created_at ASC');
    if (ruleRows.isEmpty) return const [];

    final conditionRows = await database.query(
      _conditions,
      orderBy: 'ordinal ASC',
    );
    final actionRows = await database.query(_actions, orderBy: 'ordinal ASC');

    final conditionsByRule = <String, List<RuleCondition>>{};
    for (final row in conditionRows) {
      conditionsByRule
          .putIfAbsent(row['rule_id']! as String, () => [])
          .add(_conditionFromRow(row));
    }

    final actionsByRule = <String, List<RuleAction>>{};
    for (final row in actionRows) {
      actionsByRule
          .putIfAbsent(row['rule_id']! as String, () => [])
          .add(_actionFromRow(row));
    }

    return ruleRows
        .map(
          (row) => _ruleFromRow(
            row,
            conditionsByRule[row['id']] ?? const [],
            actionsByRule[row['id']] ?? const [],
          ),
        )
        .toList();
  }

  @override
  Future<Rule?> getById(String id) async {
    final database = await _db.database;
    final ruleRows = await database.query(
      _rules,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (ruleRows.isEmpty) return null;

    final conditionRows = await database.query(
      _conditions,
      where: 'rule_id = ?',
      whereArgs: [id],
      orderBy: 'ordinal ASC',
    );
    final actionRows = await database.query(
      _actions,
      where: 'rule_id = ?',
      whereArgs: [id],
      orderBy: 'ordinal ASC',
    );

    return _ruleFromRow(
      ruleRows.first,
      conditionRows.map(_conditionFromRow).toList(),
      actionRows.map(_actionFromRow).toList(),
    );
  }

  @override
  Future<void> save(Rule rule) async {
    final database = await _db.database;
    await database.transaction((txn) async {
      await txn.insert(
        _rules,
        _ruleToRow(rule),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await txn.delete(_conditions, where: 'rule_id = ?', whereArgs: [rule.id]);
      await txn.delete(_actions, where: 'rule_id = ?', whereArgs: [rule.id]);

      for (var i = 0; i < rule.conditions.length; i++) {
        final condition = rule.conditions[i];
        await txn.insert(_conditions, {
          'id': condition.id,
          'rule_id': rule.id,
          'type': condition.type.dbValue,
          'operator': condition.operator.dbValue,
          'value': condition.value,
          'ordinal': i,
        });
      }

      for (var i = 0; i < rule.actions.length; i++) {
        final action = rule.actions[i];
        await txn.insert(_actions, {
          'id': action.id,
          'rule_id': rule.id,
          'type': action.type.dbValue,
          'value': action.value,
          'subfolder': action.subfolder,
          'ordinal': i,
        });
      }
    });
  }

  @override
  Future<void> delete(String id) async {
    final database = await _db.database;
    await database.delete(_rules, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> setEnabled(String id, bool enabled) async {
    final database = await _db.database;
    await database.update(
      _rules,
      {
        'enabled': enabled ? 1 : 0,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> recordRun(String id, {required int processedDelta}) async {
    final database = await _db.database;
    await database.rawUpdate(
      'UPDATE $_rules SET processed_count = processed_count + ?, last_run_at = ? WHERE id = ?',
      [processedDelta, DateTime.now().millisecondsSinceEpoch, id],
    );
  }

  Rule _ruleFromRow(
    Map<String, Object?> row,
    List<RuleCondition> conditions,
    List<RuleAction> actions,
  ) {
    return Rule(
      id: row['id']! as String,
      name: row['name']! as String,
      description: row['description'] as String?,
      enabled: (row['enabled'] as int? ?? 1) == 1,
      conditions: conditions,
      actions: actions,
      conflictPolicy: ConflictPolicy.fromDb(
        row['conflict_policy'] as String? ?? 'askEveryTime',
      ),
      scopeFolderPath: row['scope_path'] as String?,
      processedCount: row['processed_count'] as int? ?? 0,
      lastRunAt: row['last_run_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row['last_run_at']! as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at']! as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row['updated_at']! as int),
    );
  }

  Map<String, Object?> _ruleToRow(Rule rule) {
    return {
      'id': rule.id,
      'name': rule.name,
      'description': rule.description,
      'enabled': rule.enabled ? 1 : 0,
      'destination': rule.destination,
      'action_type': rule.primaryAction?.type.dbValue ?? 'move',
      'conflict_policy': rule.conflictPolicy.dbValue,
      'scope_path': rule.scopeFolderPath,
      'processed_count': rule.processedCount,
      'last_run_at': rule.lastRunAt?.millisecondsSinceEpoch,
      'created_at': rule.createdAt.millisecondsSinceEpoch,
      'updated_at': rule.updatedAt.millisecondsSinceEpoch,
    };
  }

  RuleCondition _conditionFromRow(Map<String, Object?> row) {
    return RuleCondition(
      id: row['id']! as String,
      type: ConditionType.fromDb(row['type']! as String),
      operator: ConditionOperator.fromDb(row['operator']! as String),
      value: row['value']! as String,
      ordinal: row['ordinal'] as int? ?? 0,
    );
  }

  RuleAction _actionFromRow(Map<String, Object?> row) {
    return RuleAction(
      id: row['id']! as String,
      type: ActionType.fromDb(row['type']! as String),
      value: row['value']! as String,
      subfolder: row['subfolder'] as String? ?? '',
      ordinal: row['ordinal'] as int? ?? 0,
    );
  }
}
