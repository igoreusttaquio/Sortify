import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/providers.dart';
import '../domain/rule.dart';
import '../domain/rule_action.dart';
import '../domain/rule_enums.dart';

/// CRUD for rules.
class RulesController extends AsyncNotifier<List<Rule>> {
  static const _uuid = Uuid();

  @override
  Future<List<Rule>> build() {
    return ref.watch(ruleRepositoryProvider).getAll();
  }

  Future<void> save(Rule rule) async {
    await ref.read(ruleRepositoryProvider).save(rule);
    await _reload();
  }

  Future<void> delete(String id) async {
    await ref.read(ruleRepositoryProvider).delete(id);
    await _reload();
  }

  Future<void> setEnabled(String id, bool enabled) async {
    await ref.read(ruleRepositoryProvider).setEnabled(id, enabled);
    await _reload();
  }

  Future<void> duplicate(Rule rule) async {
    final now = DateTime.now();
    final copy = rule.copyWith(
      id: _uuid.v4(),
      name: '${rule.name} (copy)',
      enabled: false,
      processedCount: 0,
      lastRunAt: null,
      createdAt: now,
      updatedAt: now,
      conditions: [for (final c in rule.conditions) c.copyWith(id: _uuid.v4())],
      actions: [for (final a in rule.actions) a.copyWith(id: _uuid.v4())],
    );
    await save(copy);
  }

  Future<void> recordRun(String id, {required int processedDelta}) async {
    await ref
        .read(ruleRepositoryProvider)
        .recordRun(id, processedDelta: processedDelta);
    await _reload();
  }

  Future<void> _reload() async {
    ref.invalidateSelf();
    await future;
  }
}

final rulesControllerProvider =
    AsyncNotifierProvider<RulesController, List<Rule>>(RulesController.new);

/// Creates empty drafts with stable ids for the rule builder.
Rule createEmptyRuleDraft(String name) {
  final now = DateTime.now();
  return Rule(
    id: const Uuid().v4(),
    name: name,
    enabled: true,
    actions: [
      RuleAction(id: const Uuid().v4(), type: ActionType.move, value: ''),
    ],
    createdAt: now,
    updatedAt: now,
  );
}
