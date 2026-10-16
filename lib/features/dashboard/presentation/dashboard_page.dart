import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/animations.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/icon_tile.dart';
import '../../../core/widgets/page_body.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../activity/application/activity_controller.dart';
import '../../activity/presentation/widgets/operation_tile.dart';
import '../../folders/application/folders_controller.dart';
import '../../folders/application/monitoring_controller.dart';
import '../../rules/application/rules_controller.dart';
import 'widgets/unmatched_table.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final monitoring = ref.watch(monitoringControllerProvider);
    final folders = ref.watch(foldersControllerProvider).value ?? const [];
    final rules = ref.watch(rulesControllerProvider).value ?? const [];
    final activeRules = rules.where((r) => r.enabled).length;
    final movedToday = ref.watch(movedTodayProvider);

    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedEntrance(
            child: PageHeader(
              title: l10n.dashboardTitle,
              subtitle: l10n.dashboardSubtitle,
              actions: [
                OutlinedButton.icon(
                  onPressed: monitoring.busy
                      ? null
                      : () => ref
                            .read(monitoringControllerProvider.notifier)
                            .runAll(),
                  icon: monitoring.busy
                      ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow_rounded, size: 18),
                  label: Text(l10n.paletteRunAll),
                ),
                FilledButton.icon(
                  onPressed: () =>
                      ref.read(monitoringControllerProvider.notifier).toggle(),
                  icon: AnimatedSwap(
                    child: Icon(
                      monitoring.running
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      key: ValueKey<bool>(monitoring.running),
                      size: 18,
                    ),
                  ),
                  label: Text(
                    monitoring.running ? l10n.commonPause : l10n.commonResume,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedEntrance(
            delay: const Duration(milliseconds: 50),
            child: _StatusCard(
              running: monitoring.running,
              folders: folders.length,
              rules: activeRules,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AnimatedEntrance(
            delay: const Duration(milliseconds: 100),
            child: _StatsGrid(
              movedToday: movedToday.value ?? 0,
              activeRules: activeRules,
              folders: folders.length,
              pending: monitoring.unmatched.length,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedEntrance(
            delay: const Duration(milliseconds: 150),
            child: const _RecentActivityPanel(),
          ),
          const SizedBox(height: AppSpacing.md),
          AnimatedEntrance(
            delay: const Duration(milliseconds: 180),
            child: const UnmatchedTable(),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.running,
    required this.folders,
    required this.rules,
  });

  final bool running;
  final int folders;
  final int rules;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final l10n = AppLocalizations.of(context);
    final color = running
        ? semantic.success
        : theme.colorScheme.onSurfaceVariant;

    return SurfaceCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      backgroundColor: Color.alphaBlend(
        color.withValues(alpha: 0.06),
        theme.colorScheme.surfaceContainer,
      ),
      borderColor: color.withValues(alpha: 0.25),
      child: Row(
        children: [
          IconTile(
            icon: running
                ? Icons.radar_rounded
                : Icons.pause_circle_outline_rounded,
            color: color,
            size: 46,
            iconSize: 23,
            gradient: true,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      running ? l10n.statusMonitoring : l10n.statusPaused,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    StatusPill(
                      label: '$folders',
                      color: color,
                      dot: true,
                      pulse: running,
                      dense: true,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.statusMonitoringSubtitle(folders),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          StatusPill(
            icon: Icons.bolt_rounded,
            label: l10n.activeRulesCount(rules),
            color: theme.colorScheme.primary,
            dense: true,
          ),
        ],
      ),
    );
  }
}

class _Stat {
  const _Stat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color color;
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.movedToday,
    required this.activeRules,
    required this.folders,
    required this.pending,
  });

  final int movedToday;
  final int activeRules;
  final int folders;
  final int pending;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final semantic = context.semanticColors;
    final primary = Theme.of(context).colorScheme.primary;

    final stats = [
      _Stat(
        label: l10n.statFilesToday,
        value: movedToday,
        icon: Icons.check_circle_outline_rounded,
        color: semantic.success,
      ),
      _Stat(
        label: l10n.statActiveRules,
        value: activeRules,
        icon: Icons.bolt_outlined,
        color: primary,
      ),
      _Stat(
        label: l10n.statFoldersMonitored,
        value: folders,
        icon: Icons.folder_outlined,
        color: semantic.warning,
      ),
      _Stat(
        label: l10n.statFilesPending,
        value: pending,
        icon: Icons.hourglass_empty_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 720 ? 2 : 4;
        const spacing = AppSpacing.sm;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        final rows = <Widget>[];
        for (var start = 0; start < stats.length; start += columns) {
          final chunk = stats.skip(start).take(columns).toList();
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < chunk.length; i++) ...[
                    if (i > 0) const SizedBox(width: spacing),
                    SizedBox(
                      width: itemWidth,
                      child: _StatCard(stat: chunk[i]),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const SizedBox(height: spacing),
              rows[i],
            ],
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final _Stat stat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconTile(
                icon: stat.icon,
                color: stat.color,
                size: 32,
                iconSize: 16,
                radius: AppRadius.sm,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  stat.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AnimatedCount(
            value: stat.value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentActivityPanel extends ConsumerWidget {
  const _RecentActivityPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final activity = ref.watch(activityControllerProvider);
    final hasActivity = activity.value?.isNotEmpty ?? false;

    return SurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(l10n.recentActivity, style: theme.textTheme.titleMedium),
              const Spacer(),
              if (hasActivity)
                TextButton(
                  onPressed: () => context.go(AppRoutes.activity),
                  child: Text(l10n.viewAll),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          AsyncValueView(
            value: activity,
            data: (operations) {
              if (operations.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Text(
                    l10n.noActivityBody,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }
              final recent = operations.take(6).toList();
              return Column(
                children: [
                  for (var i = 0; i < recent.length; i++)
                    AnimatedEntrance(
                      key: ValueKey<String>(recent[i].id),
                      delay: Duration(milliseconds: 40 * i),
                      slide: 0.08,
                      child: OperationTile(
                        operation: recent[i],
                        onTap: () => context.go(AppRoutes.activity),
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
