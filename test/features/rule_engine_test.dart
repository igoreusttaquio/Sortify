import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sortify/core/filesystem/file_deleter.dart';
import 'package:sortify/core/filesystem/local_file_system.dart';
import 'package:sortify/features/activity/domain/activity_repository.dart';
import 'package:sortify/features/activity/domain/file_operation.dart';
import 'package:sortify/features/rules/application/rule_engine.dart';
import 'package:sortify/features/rules/domain/rule.dart';
import 'package:sortify/features/rules/domain/rule_action.dart';
import 'package:sortify/features/rules/domain/rule_condition.dart';
import 'package:sortify/features/rules/domain/rule_enums.dart';

class _MemoryActivity implements ActivityRepository {
  final operations = <FileOperation>[];

  @override
  Future<void> insert(FileOperation operation) async =>
      operations.add(operation);

  @override
  Future<List<FileOperation>> getRecent({
    int limit = 100,
    OperationStatus? status,
  }) async => operations;

  @override
  Future<int> countMovedSince(DateTime since) async => 0;

  @override
  Future<void> clear() async => operations.clear();
}

void main() {
  late Directory root;
  late Directory watched;
  late RuleEngine engine;

  setUp(() {
    root = Directory.systemTemp.createTempSync('sortify_engine_');
    watched = Directory(p.join(root.path, 'Downloads'))..createSync();
    engine = RuleEngine(
      fileSystem: const LocalFileSystem(),
      activityRepository: _MemoryActivity(),
      fileDeleter: const FileDeleter(),
    );
  });

  tearDown(() => root.deleteSync(recursive: true));

  Rule rule({
    required List<RuleCondition> conditions,
    required RuleAction action,
  }) {
    final now = DateTime.now();
    return Rule(
      id: 'r',
      name: 'r',
      conditions: conditions,
      actions: [action],
      conflictPolicy: ConflictPolicy.keepBoth,
      createdAt: now,
      updatedAt: now,
    );
  }

  RuleCondition condition(
    ConditionType type,
    ConditionOperator operator,
    String value,
  ) => RuleCondition(id: 'c', type: type, operator: operator, value: value);

  File createFile(String name, {DateTime? modified}) {
    final file = File(p.join(watched.path, name))..writeAsStringSync('x');
    if (modified != null) file.setLastModifiedSync(modified);
    return file;
  }

  test('move creates the templated subfolder inside the destination', () async {
    final file = createFile('photo.JPG', modified: DateTime(2025, 12, 1));
    final result = await engine.processFile(
      file: file,
      watchedFolderPath: watched.path,
      rules: [
        rule(
          conditions: [
            condition(
              ConditionType.extension,
              ConditionOperator.isEqual,
              'jpg',
            ),
          ],
          action: const RuleAction(
            id: 'a',
            type: ActionType.move,
            value: 'Pictures',
            subfolder: '{year}/{ext}',
          ),
        ),
      ],
      ignoreHidden: true,
      deleteToTrash: false,
    );

    final expected = p.join(root.path, 'Pictures', '2025', 'jpg', 'photo.JPG');
    expect(result.operation?.status, OperationStatus.moved);
    expect(result.operation?.destination, expected);
    expect(File(expected).existsSync(), isTrue);
    expect(file.existsSync(), isFalse);
  });

  test('copy keeps the original and writes into a fixed subfolder', () async {
    final file = createFile('a.txt');
    await engine.processFile(
      file: file,
      watchedFolderPath: watched.path,
      rules: [
        rule(
          conditions: [
            condition(ConditionType.name, ConditionOperator.startsWith, 'a'),
          ],
          action: const RuleAction(
            id: 'a',
            type: ActionType.copy,
            value: 'Backup',
            subfolder: 'Texts',
          ),
        ),
      ],
      ignoreHidden: true,
      deleteToTrash: false,
    );

    expect(
      File(p.join(root.path, 'Backup', 'Texts', 'a.txt')).existsSync(),
      isTrue,
    );
    expect(file.existsSync(), isTrue);
  });

  test('rename expands tokens and keeps the extension', () async {
    final file = createFile('scan.pdf', modified: DateTime(2026, 1, 2));
    final result = await engine.processFile(
      file: file,
      watchedFolderPath: watched.path,
      rules: [
        rule(
          conditions: [
            condition(ConditionType.name, ConditionOperator.endsWith, 'scan'),
          ],
          action: const RuleAction(
            id: 'a',
            type: ActionType.rename,
            value: '{date}_{name}',
          ),
        ),
      ],
      ignoreHidden: true,
      deleteToTrash: false,
    );

    expect(
      result.operation?.destination,
      p.join(watched.path, '2026-01-02_scan.pdf'),
    );
  });

  test('modified condition compares file age in days', () {
    final old = createFile(
      'old.log',
      modified: DateTime.now().subtract(const Duration(days: 40)),
    );
    final fresh = createFile('new.log');
    final olderThan30 = rule(
      conditions: [
        condition(ConditionType.modified, ConditionOperator.olderThan, '30'),
      ],
      action: const RuleAction(id: 'a', type: ActionType.delete, value: ''),
    );

    Rule? match(File file) => engine.firstMatch(
      file: file,
      rules: [olderThan30],
      ignoreHidden: true,
      folderPath: watched.path,
    );

    expect(match(old), isNotNull);
    expect(match(fresh), isNull);
  });
}
