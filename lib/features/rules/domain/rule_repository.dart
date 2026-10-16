import 'rule.dart';

/// Persistence boundary for rules, including their conditions and actions.
abstract interface class RuleRepository {
  Future<List<Rule>> getAll();

  Future<Rule?> getById(String id);

  Future<void> save(Rule rule);

  Future<void> delete(String id);

  Future<void> setEnabled(String id, bool enabled);

  /// Increments the processed counter and stamps the last run time.
  Future<void> recordRun(String id, {required int processedDelta});
}
