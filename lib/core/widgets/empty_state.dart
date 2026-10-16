import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import 'animations.dart';
import 'icon_tile.dart';

/// A calm, well-composed empty state used across every screen.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: AnimatedEntrance(
        scaleFrom: 0.96,
        slide: 0.04,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Padding(
            padding: EdgeInsets.all(compact ? AppSpacing.lg : AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconTile(
                  icon: icon,
                  color: theme.colorScheme.primary,
                  size: compact ? 56 : 72,
                  iconSize: compact ? 26 : 32,
                  radius: AppRadius.xl,
                  gradient: true,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (action != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  action!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
