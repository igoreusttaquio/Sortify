import '../../../l10n/generated/app_localizations.dart';
import '../domain/rule.dart';
import '../domain/rule_condition.dart';
import '../domain/rule_enums.dart';

/// Presentation helpers that turn rule data into human readable text.
abstract final class RuleFormat {
  static String operatorLabel(
    ConditionOperator operator,
    AppLocalizations l10n,
  ) {
    return switch (operator) {
      ConditionOperator.isEqual => l10n.operatorIs,
      ConditionOperator.isNot => l10n.operatorIsNot,
      ConditionOperator.contains => l10n.operatorContains,
      ConditionOperator.doesNotContain => l10n.operatorDoesNotContain,
      ConditionOperator.greaterThan => l10n.operatorGreaterThan,
      ConditionOperator.lessThan => l10n.operatorLessThan,
      ConditionOperator.equalTo => l10n.operatorEqualTo,
    };
  }

  static String conditionTypeLabel(ConditionType type, AppLocalizations l10n) {
    return switch (type) {
      ConditionType.extension => l10n.conditionExtension,
      ConditionType.size => l10n.conditionSize,
      ConditionType.name => l10n.conditionName,
    };
  }

  static String describeCondition(
    RuleCondition condition,
    AppLocalizations l10n,
  ) {
    switch (condition.type) {
      case ConditionType.extension:
        if (condition.operator == ConditionOperator.isEqual) {
          return condition.value;
        }
        return '${operatorLabel(condition.operator, l10n)} ${condition.value}';
      case ConditionType.size:
        return '${operatorLabel(condition.operator, l10n)} ${condition.value}';
      case ConditionType.name:
        return '${operatorLabel(condition.operator, l10n)} "${condition.value}"';
    }
  }

  static String describeRule(Rule rule, AppLocalizations l10n) {
    if (rule.conditions.isEmpty) return l10n.commonComingSoon;
    return rule.conditions
        .map((c) => describeCondition(c, l10n))
        .join('   ·   ');
  }

  /// A short description of what the rule does, e.g. `Documents/PDFs`.
  static String describeAction(Rule rule, AppLocalizations l10n) {
    final action = rule.primaryAction;
    if (action == null) return l10n.actionComingSoon;
    final value = action.value.trim();
    return switch (action.type) {
      ActionType.move => value.isEmpty ? l10n.actionMove : value,
      ActionType.copy => value.isEmpty ? l10n.actionCopy : value,
      ActionType.rename => value.isEmpty ? l10n.actionRename : value,
      ActionType.delete => l10n.actionDelete,
    };
  }

  /// A representative extension for the rule icon, if one exists.
  static String? representativeExtension(Rule rule) {
    for (final condition in rule.conditions) {
      if (condition.type != ConditionType.extension) continue;
      final first = condition.value.split(',').first.trim();
      if (first.isEmpty) continue;
      return first.startsWith('.') ? first : '.$first';
    }
    return null;
  }
}
