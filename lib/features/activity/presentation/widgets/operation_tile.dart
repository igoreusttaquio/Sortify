import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/utils/display_path.dart';
import '../../../../core/widgets/file_type_icon.dart';
import '../../../../core/widgets/truncated_text.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/file_operation.dart';

class OperationStatusBadge extends StatelessWidget {
  const OperationStatusBadge({super.key, required this.status});

  final OperationStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final l10n = AppLocalizations.of(context);

    final (icon, color, label) = switch (status) {
      OperationStatus.moved => (
        Icons.check_circle_outline_rounded,
        semantic.success,
        l10n.statusMoved,
      ),
      OperationStatus.skipped => (
        Icons.error_outline_rounded,
        semantic.warning,
        l10n.statusSkipped,
      ),
      OperationStatus.failed => (
        Icons.cancel_outlined,
        theme.colorScheme.error,
        l10n.statusFailed,
      ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 5),
        Text(label, style: theme.textTheme.labelMedium?.copyWith(color: color)),
      ],
    );
  }
}

/// A single activity row, reused by the dashboard and the activity page.
class OperationTile extends StatelessWidget {
  const OperationTile({
    super.key,
    required this.operation,
    this.onTap,
    this.showTime = true,
  });

  final FileOperation operation;
  final VoidCallback? onTap;
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final subtitle =
        operation.status == OperationStatus.skipped &&
            operation.destination == null
        ? operation.error ?? l10n.noMatchingRule
        : DisplayPath.summary(operation.source, operation.destination);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      hoverColor: context.semanticColors.hover,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            FileTypeIcon(path: operation.fileName, size: 36, iconSize: 18),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TruncatedText(
                    operation.fileName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 1),
                  TruncatedText(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                OperationStatusBadge(status: operation.status),
                if (showTime) ...[
                  const SizedBox(height: 2),
                  Text(
                    DateFormat.Hm().format(operation.createdAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
