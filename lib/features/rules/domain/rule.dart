import 'package:freezed_annotation/freezed_annotation.dart';

import 'rule_action.dart';
import 'rule_condition.dart';
import 'rule_enums.dart';

part 'rule.freezed.dart';

/// An organizing rule: a set of AND-combined conditions and one or more
/// actions. The MVP only executes the first [ActionType.move] action.
@freezed
abstract class Rule with _$Rule {
  const Rule._();

  const factory Rule({
    required String id,
    required String name,
    String? description,
    @Default(true) bool enabled,
    @Default(<RuleCondition>[]) List<RuleCondition> conditions,
    @Default(<RuleAction>[]) List<RuleAction> actions,
    @Default(ConflictPolicy.askEveryTime) ConflictPolicy conflictPolicy,
    @Default(0) int processedCount,
    DateTime? lastRunAt,

    /// When set, the rule only applies to files inside this watched folder.
    /// `null` (default) means it applies to every watched folder.
    String? scopeFolderPath,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Rule;

  /// Whether the rule targets every watched folder.
  bool get isGlobalScope => scopeFolderPath == null;

  /// The action the engine executes in the MVP.
  RuleAction? get primaryAction => actions.isEmpty ? null : actions.first;

  /// Convenience accessor for the destination path of the primary action.
  String? get destination => primaryAction?.value;

  bool get hasDestination =>
      primaryAction != null && primaryAction!.value.trim().isNotEmpty;

  /// Whether the primary action has everything it needs to run. `delete` needs
  /// no value; every other action needs a non-empty value.
  bool get isActionReady {
    final action = primaryAction;
    if (action == null) return false;
    if (action.type == ActionType.delete) return true;
    return action.value.trim().isNotEmpty;
  }
}
