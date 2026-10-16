import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/notifications/notification_controller.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/display_path.dart';
import '../../../core/widgets/animations.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/icon_tile.dart';
import '../../../core/widgets/page_body.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/truncated_text.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/folders_controller.dart';
import '../domain/watched_folder.dart';
import 'folder_actions.dart';

class FoldersPage extends ConsumerWidget {
  const FoldersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final folders = ref.watch(foldersControllerProvider);

    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeader(
            title: l10n.foldersTitle,
            subtitle: l10n.foldersSubtitle,
            actions: [
              FilledButton.icon(
                onPressed: () => addWatchedFolderFlow(context, ref),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(l10n.addFolder),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AsyncValueView(
            value: folders,
            onRetry: () => ref.invalidate(foldersControllerProvider),
            data: (items) {
              if (items.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xxl),
                  child: EmptyState(
                    icon: Icons.folder_off_outlined,
                    title: l10n.noFoldersTitle,
                    message: l10n.noFoldersBody,
                    action: FilledButton.icon(
                      onPressed: () => addWatchedFolderFlow(context, ref),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(l10n.noFoldersAction),
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
                        child: _FolderCard(folder: items[i]),
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

class _FolderCard extends ConsumerWidget {
  const _FolderCard({required this.folder});

  final WatchedFolder folder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(foldersControllerProvider.notifier);

    return SurfaceCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          IconTile(
            icon: Icons.folder_rounded,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(folder.name, style: theme.textTheme.titleSmall),
                const SizedBox(height: 2),
                TruncatedText(
                  DisplayPath.shorten(folder.path),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatusPill(
                label: folder.enabled
                    ? l10n.folderMonitoring
                    : l10n.folderPaused,
                color: folder.enabled
                    ? semantic.success
                    : theme.colorScheme.onSurfaceVariant,
                dot: true,
                pulse: folder.enabled,
                dense: true,
              ),
              const SizedBox(width: AppSpacing.xs),
              PopupMenuButton<String>(
                tooltip: '',
                icon: const Icon(Icons.more_vert_rounded, size: 18),
                onSelected: (value) async {
                  switch (value) {
                    case 'toggle':
                      await controller.setEnabled(folder.id, !folder.enabled);
                    case 'open':
                      await ref
                          .read(localFileSystemProvider)
                          .revealInFileManager(folder.path);
                    case 'remove':
                      final confirmed = await showConfirmDialog(
                        context,
                        title: l10n.removeFolderConfirmTitle,
                        message: l10n.removeFolderConfirmBody(folder.path),
                        confirmLabel: l10n.removeFolder,
                        destructive: true,
                      );
                      if (confirmed) {
                        await controller.remove(folder.id);
                        if (context.mounted) {
                          ref
                              .read(notificationProvider.notifier)
                              .success(l10n.folderRemoved);
                        }
                      }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'toggle',
                    child: _menuRow(
                      context,
                      folder.enabled
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      folder.enabled ? l10n.commonPause : l10n.commonResume,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'open',
                    child: _menuRow(
                      context,
                      Icons.open_in_new_rounded,
                      l10n.revealInExplorer,
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'remove',
                    child: _menuRow(
                      context,
                      Icons.delete_outline_rounded,
                      l10n.removeFolder,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuRow(
    BuildContext context,
    IconData icon,
    String label, {
    Color? color,
  }) {
    return Row(
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
    );
  }
}
