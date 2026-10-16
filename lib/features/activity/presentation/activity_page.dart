import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/animations.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_body.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/activity_controller.dart';
import '../domain/file_operation.dart';
import 'widgets/operation_tile.dart';

class ActivityPage extends ConsumerWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final activity = ref.watch(activityControllerProvider);
    final filter = ref.watch(activityFilterProvider);

    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeader(
            title: l10n.activityTitle,
            subtitle: l10n.activitySubtitle,
            actions: [
              OutlinedButton.icon(
                onPressed: () async {
                  final confirmed = await showConfirmDialog(
                    context,
                    title: l10n.clearHistory,
                    message: l10n.clearHistoryConfirm,
                    confirmLabel: l10n.commonDelete,
                    destructive: true,
                  );
                  if (confirmed) {
                    await ref.read(activityControllerProvider.notifier).clear();
                  }
                },
                icon: const Icon(Icons.delete_sweep_outlined, size: 17),
                label: Text(l10n.clearHistory),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ChoicePills<OperationStatus?>(
            value: filter,
            onChanged: (status) =>
                ref.read(activityFilterProvider.notifier).set(status),
            options: [
              ChoiceOption(value: null, label: l10n.filterAll),
              ChoiceOption(
                value: OperationStatus.moved,
                label: l10n.filterMoved,
              ),
              ChoiceOption(
                value: OperationStatus.skipped,
                label: l10n.filterSkipped,
              ),
              ChoiceOption(
                value: OperationStatus.failed,
                label: l10n.filterFailed,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AsyncValueView(
            value: activity,
            onRetry: () => ref.invalidate(activityControllerProvider),
            data: (operations) {
              final filtered = filter == null
                  ? operations
                  : operations.where((o) => o.status == filter).toList();

              if (filtered.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xxl),
                  child: EmptyState(
                    icon: Icons.history_toggle_off_rounded,
                    title: operations.isEmpty
                        ? l10n.noActivityTitle
                        : l10n.noActivityFilteredTitle,
                    message: operations.isEmpty
                        ? l10n.noActivityBody
                        : l10n.noActivityFilteredBody,
                  ),
                );
              }

              return _Timeline(
                operations: filtered,
                onTap: (operation) => _showDetails(context, operation, l10n),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDetails(
    BuildContext context,
    FileOperation operation,
    AppLocalizations l10n,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(l10n.operationDetails),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    label: l10n.detailStatus,
                    child: OperationStatusBadge(status: operation.status),
                  ),
                  _DetailRow(
                    label: l10n.detailTimestamp,
                    child: Text(
                      DateFormat.yMMMMd().add_Hm().format(operation.createdAt),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  _DetailRow(
                    label: l10n.detailSource,
                    child: SelectableText(
                      operation.source,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  if (operation.destination != null)
                    _DetailRow(
                      label: l10n.detailDestination,
                      child: SelectableText(
                        operation.destination!,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  _DetailRow(
                    label: l10n.detailRule,
                    child: Text(
                      operation.ruleName ?? l10n.noMatchingRule,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  _DetailRow(
                    label: l10n.detailOperation,
                    child: Text(
                      operation.operation.dbValue,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  if (operation.error != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    _ErrorBanner(message: operation.error!),
                  ],
                  const SizedBox(height: AppSpacing.xs),
                  _TechnicalDetails(operation: operation, l10n: l10n),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.commonClose),
            ),
          ],
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.operations, required this.onTap});

  final List<FileOperation> operations;
  final ValueChanged<FileOperation> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final groups = <String, List<FileOperation>>{};
    for (final operation in operations) {
      final key = _dayLabel(operation.createdAt, l10n);
      groups.putIfAbsent(key, () => []).add(operation);
    }

    final entries = groups.entries.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < entries.length; i++)
          AnimatedEntrance(
            key: ValueKey<String>(entries[i].key),
            delay: Duration(milliseconds: 50 * i),
            slide: 0.05,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xs,
                    AppSpacing.md,
                    AppSpacing.xs,
                    AppSpacing.xs,
                  ),
                  child: Text(
                    entries[i].key,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SurfaceCard(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Column(
                    children: [
                      for (final operation in entries[i].value)
                        OperationTile(
                          operation: operation,
                          onTap: () => onTap(operation),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _dayLabel(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final difference = today.difference(day).inDays;
    if (difference == 0) return l10n.today;
    if (difference == 1) return l10n.yesterday;
    return DateFormat.yMMMMd().format(date);
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final error = theme.colorScheme.error;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: error.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, size: 16, color: error),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: SelectableText(
              message,
              style: theme.textTheme.bodySmall?.copyWith(color: error),
            ),
          ),
        ],
      ),
    );
  }
}

/// Collapsible section with the raw operation fields, useful for debugging.
class _TechnicalDetails extends StatefulWidget {
  const _TechnicalDetails({required this.operation, required this.l10n});

  final FileOperation operation;
  final AppLocalizations l10n;

  @override
  State<_TechnicalDetails> createState() => _TechnicalDetailsState();
}

class _TechnicalDetailsState extends State<_TechnicalDetails> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final l10n = widget.l10n;
    final operation = widget.operation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: _open ? 0.25 : 0,
                  duration: AppMotion.fast,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  l10n.technicalDetails,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: AppMotion.normal,
          crossFadeState: _open
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: AppSpacing.xxs),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: semantic.subtleBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _techRow(context, l10n.detailOperationId, operation.id),
                _techRow(context, l10n.detailRuleId, operation.ruleId ?? '—'),
                _techRow(context, l10n.detailRule, operation.ruleName ?? '—'),
                _techRow(
                  context,
                  l10n.detailOperation,
                  operation.operation.dbValue,
                ),
                _techRow(context, l10n.detailStatus, operation.status.dbValue),
                _techRow(
                  context,
                  l10n.detailTimestamp,
                  operation.createdAt.toIso8601String(),
                ),
                _techRow(context, l10n.detailSource, operation.source),
                _techRow(
                  context,
                  l10n.detailDestination,
                  operation.destination ?? '—',
                ),
                if (operation.error != null)
                  _techRow(
                    context,
                    l10n.detailError,
                    operation.error!,
                    isError: true,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _techRow(
    BuildContext context,
    String label,
    String value, {
    bool isError = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: SelectableText(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isError
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurface,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
