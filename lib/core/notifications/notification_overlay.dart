import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';
import 'app_notification.dart';
import 'notification_controller.dart';

/// Shows notifications stacked in the top-right corner of the window.
class NotificationOverlay extends ConsumerWidget {
  const NotificationOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(notificationProvider);
    if (items.isEmpty) return const SizedBox.shrink();
    final notifier = ref.read(notificationProvider.notifier);

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppLayout.headerHeight + AppSpacing.sm,
          right: AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final notification in items)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: _NotificationCard(
                  key: ValueKey<String>(notification.id),
                  notification: notification,
                  onDismiss: () => notifier.dismiss(notification.id),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatefulWidget {
  const _NotificationCard({
    super.key,
    required this.notification,
    required this.onDismiss,
  });

  final AppNotification notification;
  final VoidCallback onDismiss;

  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.normal,
    reverseDuration: AppMotion.fast,
  );
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _timer = Timer(widget.notification.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    _timer?.cancel();
    if (!mounted) return;
    await _controller.reverse();
    if (mounted) widget.onDismiss();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final notification = widget.notification;

    final (color, icon) = switch (notification.type) {
      AppNotificationType.success => (
        semantic.success,
        Icons.check_circle_rounded,
      ),
      AppNotificationType.error => (
        theme.colorScheme.error,
        Icons.error_rounded,
      ),
      AppNotificationType.info => (
        theme.colorScheme.primary,
        Icons.info_rounded,
      ),
    };

    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeIn,
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.18, 0),
          end: Offset.zero,
        ).animate(curved),
        child: Container(
          width: 360,
          decoration: BoxDecoration(
            color: Color.alphaBlend(
              color.withValues(alpha: 0.14),
              theme.colorScheme.surfaceContainerHigh,
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: color.withValues(alpha: 0.42)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.xs,
            AppSpacing.xxs,
            AppSpacing.xs,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.message,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (notification.hasAction) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: color,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                            ),
                            minimumSize: const Size(0, 30),
                          ),
                          onPressed: () {
                            _timer?.cancel();
                            notification.onAction!();
                            widget.onDismiss();
                          },
                          child: Text(notification.actionLabel!),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                iconSize: 16,
                visualDensity: VisualDensity.compact,
                onPressed: _dismiss,
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
