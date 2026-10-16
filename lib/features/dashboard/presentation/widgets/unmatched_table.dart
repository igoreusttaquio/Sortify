import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/notifications/notification_controller.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/animations.dart';
import '../../../../core/widgets/choice_pills.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/file_type_icon.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../../core/widgets/truncated_text.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../activity/application/activity_controller.dart';
import '../../../activity/domain/file_operation.dart';
import '../../../folders/application/monitoring_controller.dart';
import '../../../folders/domain/unmatched_file.dart';
import '../../../rules/application/rule_builder_seed.dart';
import '../../../rules/application/rule_editor_controller.dart';
import '../../../settings/application/settings_controller.dart';
import '../../../settings/domain/app_settings.dart';

/// Table of files that no rule matches, with a type filter, a "create global
/// rule for this type" action and pagination.
class UnmatchedTable extends ConsumerStatefulWidget {
  const UnmatchedTable({super.key});

  @override
  ConsumerState<UnmatchedTable> createState() => _UnmatchedTableState();
}

class _UnmatchedTableState extends ConsumerState<UnmatchedTable> {
  static const _pageSize = 8;

  String? _type;
  int _page = 0;

  void _createRuleForFile(UnmatchedFile file) {
    ref.read(ruleBuilderSeedProvider.notifier).seedFromFile(file.path);
    ref.read(ruleEditorProvider.notifier).openNew();
  }

  Future<void> _deleteFile(UnmatchedFile file) async {
    final l10n = AppLocalizations.of(context);
    final useTrash =
        ref.read(settingsControllerProvider).deleteBehavior ==
        DeleteBehavior.trash;

    final confirmed = await showConfirmDialog(
      context,
      title: l10n.deleteFileConfirmTitle,
      message: useTrash
          ? l10n.deleteFileConfirmTrash(file.fileName)
          : l10n.deleteFileConfirmPermanent(file.fileName),
      confirmLabel: l10n.commonDelete,
      destructive: true,
    );
    if (!confirmed || !mounted) return;

    final result = await ref
        .read(fileDeleterProvider)
        .delete(file.path, toTrash: useTrash);
    if (!mounted) return;

    await ref
        .read(activityRepositoryProvider)
        .insert(
          FileOperation(
            id: const Uuid().v4(),
            fileName: file.fileName,
            source: file.path,
            operation: OperationKind.delete,
            status: result.success
                ? OperationStatus.moved
                : OperationStatus.failed,
            error: result.error,
            createdAt: DateTime.now(),
          ),
        );
    await ref.read(monitoringControllerProvider.notifier).refreshUnmatched();
    ref.invalidate(activityControllerProvider);
    ref.invalidate(movedTodayProvider);
    if (!mounted) return;

    final notifications = ref.read(notificationProvider.notifier);
    if (result.success) {
      notifications.success(l10n.fileDeleted);
    } else {
      notifications.error(result.error ?? l10n.commonError);
    }
  }

  void _createRuleForType(String type) {
    ref.read(ruleBuilderSeedProvider.notifier).seedFromExtension(type);
    ref.read(ruleEditorProvider.notifier).openNew();
  }

  void _ignoreType(String type) {
    final normalized = type.trim().toLowerCase();
    setState(() => _type = null);
    if (normalized.isEmpty) return;

    final current = ref.read(settingsControllerProvider).ignoredExtensions;
    if (current.contains(normalized)) return;
    ref
        .read(settingsControllerProvider.notifier)
        .update(
          (s) => s.copyWith(
            ignoredExtensions: [...s.ignoredExtensions, normalized]..sort(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final files = ref.watch(unmatchedProvider);

    // Ignore a selected type that no longer exists in the list.
    final effectiveType =
        (_type != null && files.any((f) => f.extension == _type))
        ? _type
        : null;
    final filtered = effectiveType == null
        ? files
        : files.where((f) => f.extension == effectiveType).toList();

    return SurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(theme, l10n, files.length, effectiveType),
          const SizedBox(height: AppSpacing.sm),
          if (files.isEmpty)
            _emptyState(context, theme, l10n)
          else ...[
            _filters(l10n, files, effectiveType),
            const SizedBox(height: AppSpacing.sm),
            const _TableHeaderRow(),
            Divider(height: 1, color: context.semanticColors.subtleBorder),
            ..._buildRows(filtered),
            _pagination(theme, l10n, filtered),
          ],
        ],
      ),
    );
  }

  Widget _header(
    ThemeData theme,
    AppLocalizations l10n,
    int total,
    String? effectiveType,
  ) {
    // Fixed height so showing/hiding the action pill does not resize the table.
    return SizedBox(
      height: 34,
      child: Row(
        children: [
          Text(l10n.unmatchedTitle, style: theme.textTheme.titleMedium),
          const SizedBox(width: AppSpacing.xs),
          if (total > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: context.semanticColors.warning.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: AnimatedCount(
                value: total,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: context.semanticColors.warning,
                ),
              ),
            ),
          const Spacer(),
          if (effectiveType != null) ...[
            _ActionPill(
              icon: Icons.bolt_rounded,
              label: l10n.createRuleForType(
                '.${effectiveType.isEmpty ? '—' : effectiveType}',
              ),
              onTap: () => _createRuleForType(effectiveType),
            ),
            const SizedBox(width: AppSpacing.xs),
            _ActionPill(
              secondary: true,
              icon: Icons.visibility_off_outlined,
              label: l10n.ignoreType(
                '.${effectiveType.isEmpty ? '—' : effectiveType}',
              ),
              onTap: () => _ignoreType(effectiveType),
            ),
          ],
        ],
      ),
    );
  }

  Widget _emptyState(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: context.semanticColors.success,
            size: 26,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.unmatchedCount(0),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filters(
    AppLocalizations l10n,
    List<UnmatchedFile> files,
    String? effectiveType,
  ) {
    final counts = <String, int>{};
    for (final file in files) {
      final key = file.extension;
      counts[key] = (counts[key] ?? 0) + 1;
    }
    final types = counts.keys.toList()
      ..sort((a, b) {
        final byCount = counts[b]!.compareTo(counts[a]!);
        return byCount != 0 ? byCount : a.compareTo(b);
      });

    ChoiceOption<String?> option(String? value, String label) {
      final count = value == null ? files.length : counts[value] ?? 0;
      return ChoiceOption(value: value, label: '$label ($count)');
    }

    return ChoicePills<String?>(
      dense: true,
      scrollable: true,
      value: effectiveType,
      onChanged: (value) => setState(() {
        _type = value;
        _page = 0;
      }),
      options: [
        option(null, l10n.allTypes),
        for (final type in types) option(type, type.isEmpty ? '—' : '.$type'),
      ],
    );
  }

  List<Widget> _buildRows(List<UnmatchedFile> filtered) {
    final pageCount = math.max(1, (filtered.length / _pageSize).ceil());
    final page = _page >= pageCount ? pageCount - 1 : (_page < 0 ? 0 : _page);
    final start = page * _pageSize;
    final pageItems = filtered.skip(start).take(_pageSize).toList();

    return [
      for (final file in pageItems)
        _UnmatchedRow(
          key: ValueKey<String>(file.path),
          file: file,
          onCreateRule: () => _createRuleForFile(file),
          onDelete: () => _deleteFile(file),
        ),
    ];
  }

  Widget _pagination(
    ThemeData theme,
    AppLocalizations l10n,
    List<UnmatchedFile> filtered,
  ) {
    final pageCount = (filtered.length / _pageSize).ceil();
    if (pageCount <= 1) return const SizedBox.shrink();

    final page = _page >= pageCount ? pageCount - 1 : _page;
    final start = page * _pageSize;
    final end = math.min(start + _pageSize, filtered.length);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        children: [
          Text(
            l10n.paginationSummary(start + 1, end, filtered.length),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: l10n.paginationPrev,
            onPressed: page > 0 ? () => setState(() => _page = page - 1) : null,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Text('${page + 1} / $pageCount', style: theme.textTheme.labelMedium),
          IconButton(
            tooltip: l10n.paginationNext,
            onPressed: page < pageCount - 1
                ? () => setState(() => _page = page + 1)
                : null,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

class _TableHeaderRow extends StatelessWidget {
  const _TableHeaderRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final style = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      letterSpacing: 0.4,
    );

    Widget cell(String text, {int? flex, double? width}) {
      final child = Text(text, style: style);
      if (width != null) return SizedBox(width: width, child: child);
      return Expanded(flex: flex ?? 1, child: child);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          cell(l10n.tableFile, flex: 4),
          const SizedBox(width: AppSpacing.sm),
          cell(l10n.tableType, width: 64),
          const SizedBox(width: AppSpacing.sm),
          cell(l10n.tableFolder, flex: 2),
          const SizedBox(width: 72),
        ],
      ),
    );
  }
}

class _UnmatchedRow extends StatefulWidget {
  const _UnmatchedRow({
    super.key,
    required this.file,
    required this.onCreateRule,
    required this.onDelete,
  });

  final UnmatchedFile file;
  final VoidCallback onCreateRule;
  final VoidCallback onDelete;

  @override
  State<_UnmatchedRow> createState() => _UnmatchedRowState();
}

class _UnmatchedRowState extends State<_UnmatchedRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final semantic = context.semanticColors;
    final type = widget.file.extension;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: _hovered ? semantic.hover : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  FileTypeIcon(path: widget.file.path, size: 30, iconSize: 15),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: TruncatedText(
                      widget.file.fileName,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 64,
              child: Text(
                type.isEmpty ? '—' : '.$type',
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 2,
              child: TruncatedText(
                widget.file.folderName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(
              width: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _RowAction(
                    tooltip: l10n.createRuleFromFile,
                    icon: Icons.add_circle_outline_rounded,
                    onPressed: widget.onCreateRule,
                  ),
                  _RowAction(
                    tooltip: l10n.deleteFile,
                    icon: Icons.delete_outline_rounded,
                    color: theme.colorScheme.error,
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RowAction extends StatelessWidget {
  const _RowAction({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      iconSize: 16,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints.tightFor(width: 34, height: 34),
      color: color ?? theme.colorScheme.onSurfaceVariant,
      icon: Icon(icon),
    );
  }
}

class _ActionPill extends StatefulWidget {
  const _ActionPill({
    required this.icon,
    required this.label,
    required this.onTap,
    this.secondary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool secondary;

  @override
  State<_ActionPill> createState() => _ActionPillState();
}

class _ActionPillState extends State<_ActionPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final primary = theme.colorScheme.primary;

    final Color background;
    final Color border;
    final Color foreground;
    final List<BoxShadow> shadow;

    if (widget.secondary) {
      background = _hovered ? semantic.hover : Colors.transparent;
      border = semantic.subtleBorder;
      foreground = theme.colorScheme.onSurfaceVariant;
      shadow = const [];
    } else {
      background = _hovered ? Color.lerp(primary, Colors.white, 0.1)! : primary;
      border = primary;
      foreground = theme.colorScheme.onPrimary;
      shadow = [
        BoxShadow(
          color: primary.withValues(alpha: 0.28),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: border),
            boxShadow: shadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 15, color: foreground),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: foreground,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
