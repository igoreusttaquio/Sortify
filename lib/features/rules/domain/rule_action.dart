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

    /// Optional subfolder created inside the destination for move/copy. May
    /// contain name template tokens (see `NameTemplate`) and separators for
    /// nested folders, e.g. `{year}/{month}`. Empty means no subfolder.
    @Default('') String subfolder,
    @Default(0) int ordinal,
  }) = _RuleAction;
}
