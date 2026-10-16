import 'package:freezed_annotation/freezed_annotation.dart';

import 'rule_enums.dart';

part 'rule_action.freezed.dart';

/// A single `THEN` clause of a rule.
@freezed
abstract class RuleAction with _$RuleAction {
  const factory RuleAction({
    required String id,
    required ActionType type,
    required String value,
    @Default(0) int ordinal,
  }) = _RuleAction;
}
