import 'package:freezed_annotation/freezed_annotation.dart';

import 'rule_enums.dart';

part 'rule_condition.freezed.dart';

/// A single `WHEN` clause of a rule.
@freezed
abstract class RuleCondition with _$RuleCondition {
  const factory RuleCondition({
    required String id,
    required ConditionType type,
    required ConditionOperator operator,
    required String value,
    @Default(0) int ordinal,
  }) = _RuleCondition;
}
