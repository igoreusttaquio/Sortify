import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;

import '../../../core/notifications/notification_controller.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/animations.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/file_type_icon.dart';
import '../../../core/widgets/icon_tile.dart';
import '../../../core/widgets/page_body.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/truncated_text.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../folders/application/monitoring_controller.dart';
import '../application/rule_editor_controller.dart';
import '../application/rules_controller.dart';
import '../domain/rule.dart';
import 'rule_format.dart';

class RulesPage extends ConsumerWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rules = ref.watch(rulesControllerProvider);

    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeader(
            title: l10n.rulesTitle,
            subtitle: l10n.rulesSubtitle,
            actions: [
              FilledButton.icon(
                onPressed: () =>
                    ref.read(ruleEditorProvider.notifier).openNew(),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(l10n.newRule),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AsyncValueView(
            value: rules,
            onRetry: () => ref.invalidate(rulesControllerProvider),
            data: (items) {
              if (items.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xxl),
                  child: EmptyState(
                    icon: Icons.bolt_outlined,
                    title: l10n.noRulesTitle,
                    message: l10n.noRulesBody,
                    action: FilledButton.icon(
                      onPressed: () =>
                          ref.read(ruleEditorProvider.notifier).openNew(),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(l10n.noRulesAction),
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  for (var i = 0; i < items.length; i++)
                    AnimatedEntrance(
                      key: ValueKey<String>(items[i].id),
                      delay: Duration(milliseconds: 35 * i),
                      slide: 0.06,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _RuleCard(rule: items[i]),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RuleCard extends ConsumerWidget {
  const _RuleCard({required this.rule});

  final Rule rule;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final l10n = AppLocalizations.of(context);
    final extension = RuleFormat.representativeExtension(rule);
    final controller = ref.read(rulesControllerProvider.notifier);

    return SurfaceCard(
      onTap: () => ref.read(ruleEditorProvider.notifier).openEdit(rule.id),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          if (extension != null)
            FileTypeIcon(path: 'file$extension', size: 42, iconSize: 20)
          else
            IconTile(
              icon: Icons.bolt_rounded,
              color: theme.colorScheme.primary,
              size: 42,
              iconSize: 20,
            ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: TruncatedText(
                        rule.name,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Flexible(
                      child: _ScopeBadge(
                        folderPath: rule.scopeFolderPath,
                        l10n: l10n,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                TruncatedText(
                  rule.description?.isNotEmpty == true
                      ? rule.description!
                      : RuleFormat.describeRule(rule, l10n),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.subdirectory_arrow_right_rounded,
                      size: 13,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: TruncatedText(
                        RuleFormat.describeAction(rule, l10n),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      l10n.ruleProcessed(rule.processedCount),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          StatusPill(
            label: rule.enabled ? l10n.enabled : l10n.disabled,
            color: rule.enabled
                ? semantic.success
                : theme.colorScheme.onSurfaceVariant,
            dot: true,
            dense: true,
          ),
          const SizedBox(width: AppSpacing.xs),
          PopupMenuButton<String>(
            tooltip: '',
            icon: const Icon(Icons.more_vert_rounded, size: 18),
            onSelected: (value) async {
              final notifications = ref.read(notificationProvider.notifier);
              switch (value) {
                case 'edit':
                  ref.read(ruleEditorProvider.notifier).openEdit(rule.id);
                case 'duplicate':
                  await controller.duplicate(rule);
                case 'toggle':
                  await controller.setEnabled(rule.id, !rule.enabled);
                case 'run':
                  final moved = await ref
                      .read(monitoringControllerProvider.notifier)
                      .applyRule(rule);
                  notifications.success(l10n.commonFiles(moved));
                case 'activity':
                  context.go(AppRoutes.activity);
                case 'delete':
                  final confirmed = await showConfirmDialog(
                    context,
                    title: l10n.deleteRule,
                    message: rule.name,
                    confirmLabel: l10n.commonDelete,
                    destructive: true,
                  );
                  if (confirmed) {
                    await controller.delete(rule.id);
                    notifications.success(
                      l10n.ruleDeleted,
                      actionLabel: l10n.undo,
                      onAction: () => controller.save(rule),
                    );
                  }
              }
            },
            itemBuilder: (context) => [
              _item(context, 'edit', Icons.edit_outlined, l10n.commonEdit),
              _item(
                context,
                'duplicate',
                Icons.copy_all_outlined,
                l10n.duplicateRule,
              ),
              _item(
                context,
                'toggle',
                rule.enabled
                    ? Icons.pause_circle_outline_rounded
                    : Icons.play_circle_outline_rounded,
                rule.enabled ? l10n.disableRule : l10n.enableRule,
              ),
              _item(context, 'run', Icons.play_arrow_rounded, l10n.runRuleNow),
              _item(
                context,
                'activity',
                Icons.history_rounded,
                l10n.viewRuleActivity,
              ),
              const PopupMenuDivider(),
              _item(
                context,
                'delete',
                Icons.delete_outline_rounded,
                l10n.deleteRule,
                color: theme.colorScheme.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _item(
    BuildContext context,
    String value,
    IconData icon,
    String label, {
    Color? color,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: color),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScopeBadge extends StatelessWidget {
  const _ScopeBadge({required this.folderPath, required this.l10n});

  final String? folderPath;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = folderPath == null
        ? l10n.allFolders
        : p.basename(folderPath!);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.folder_outlined,
          size: 12,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 3),
        Flexible(
          child: TruncatedText(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
