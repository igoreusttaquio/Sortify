import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../folders/application/folders_controller.dart';
import '../application/sidebar_controller.dart';
import 'sidebar_item.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final l10n = AppLocalizations.of(context);
    final collapsed = ref.watch(sidebarCollapsedProvider);
    final location = GoRouterState.of(context).uri.path;
    final foldersAsync = ref.watch(foldersControllerProvider);
    final folders = foldersAsync.value ?? const [];

    void go(String path) => context.go(path);

    return AnimatedContainer(
      duration: AppMotion.normal,
      curve: Curves.easeOutCubic,
      clipBehavior: Clip.hardEdge,
      width: collapsed
          ? AppLayout.sidebarCollapsedWidth
          : AppLayout.sidebarWidth,
      decoration: BoxDecoration(
        color: semantic.sidebar,
        border: Border(right: BorderSide(color: semantic.subtleBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.sm),
          if (!collapsed) _SectionLabel(label: l10n.navWorkspace),
          SidebarItem(
            collapsed: collapsed,
            icon: Icons.dashboard_outlined,
            label: l10n.navDashboard,
            selected: location == AppRoutes.dashboard,
            onTap: () => go(AppRoutes.dashboard),
          ),
          SidebarItem(
            collapsed: collapsed,
            icon: Icons.bolt_outlined,
            label: l10n.navRules,
            selected: location.startsWith(AppRoutes.rules),
            onTap: () => go(AppRoutes.rules),
          ),
          SidebarItem(
            collapsed: collapsed,
            icon: Icons.history_rounded,
            label: l10n.navActivity,
            selected: location == AppRoutes.activity,
            onTap: () => go(AppRoutes.activity),
          ),
          const SizedBox(height: AppSpacing.md),
          if (!collapsed) _SectionLabel(label: l10n.navLocations),
          SidebarItem(
            collapsed: collapsed,
            icon: Icons.folder_outlined,
            label: l10n.navFolders,
            selected: location == AppRoutes.folders,
            onTap: () => go(AppRoutes.folders),
          ),
          Expanded(
            child: collapsed
                ? const SizedBox.shrink()
                : ListView(
                    padding: const EdgeInsets.only(top: AppSpacing.xxs),
                    children: [
                      for (final folder in folders)
                        SidebarItem(
                          dense: true,
                          icon: Icons.folder_rounded,
                          label: folder.name,
                          selected: false,
                          trailing: Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(right: AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: folder.enabled
                                  ? semantic.success
                                  : theme.colorScheme.onSurfaceVariant,
                              shape: BoxShape.circle,
                            ),
                          ),
                          onTap: () => go(AppRoutes.folders),
                        ),
                    ],
                  ),
          ),
          Divider(height: 1, color: semantic.subtleBorder),
          const SizedBox(height: AppSpacing.xs),
          SidebarItem(
            collapsed: collapsed,
            icon: collapsed
                ? Icons.chevron_right_rounded
                : Icons.chevron_left_rounded,
            label: collapsed ? l10n.expandMenu : l10n.collapseMenu,
            selected: false,
            onTap: () => ref.read(sidebarCollapsedProvider.notifier).toggle(),
          ),
          const SizedBox(height: AppSpacing.xxs),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xxs,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
          letterSpacing: 0.8,
          fontWeight: FontWeight.w600,
          fontSize: 10.5,
        ),
      ),
    );
  }
}
