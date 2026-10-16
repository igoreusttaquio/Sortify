import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/notifications/notification_overlay.dart';
import '../../../core/theme/app_tokens.dart';
import '../../command_palette/application/command_palette_controller.dart';
import '../../command_palette/presentation/command_palette_overlay.dart';
import '../../rules/presentation/rule_editor_overlay.dart';
import 'sidebar.dart';
import 'top_bar.dart';
import 'tray_coordinator.dart';

/// The persistent desktop frame: top bar, sidebar and the routed content.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).uri.path;

    return TrayCoordinator(
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyK, control: true): () =>
              ref.read(commandPaletteProvider.notifier).toggle(),
          const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () =>
              ref.read(commandPaletteProvider.notifier).toggle(),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            backgroundColor: theme.colorScheme.surface,
            body: Stack(
              children: [
                Column(
                  children: [
                    const TopBar(),
                    Expanded(
                      child: Row(
                        children: [
                          const Sidebar(),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: AppMotion.normal,
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder: (child, animation) {
                                final curved = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                );
                                return FadeTransition(
                                  opacity: curved,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.012),
                                      end: Offset.zero,
                                    ).animate(curved),
                                    child: child,
                                  ),
                                );
                              },
                              child: KeyedSubtree(
                                key: ValueKey<String>(location),
                                child: child,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const RuleEditorOverlay(),
                const CommandPaletteOverlay(),
                const NotificationOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
