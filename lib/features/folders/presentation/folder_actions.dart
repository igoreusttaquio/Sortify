import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notifications/app_notification.dart';
import '../../../core/notifications/notification_controller.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/folders_controller.dart';
import '../application/monitoring_controller.dart';

/// Opens a directory picker, previews the choice and starts monitoring.
///
/// Returns `true` when a folder was added.
Future<bool> addWatchedFolderFlow(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);

  final path = await FilePicker.getDirectoryPath(
    dialogTitle: l10n.folderPickerTitle,
  );
  if (path == null || !context.mounted) return false;

  final confirmed = await showConfirmDialog(
    context,
    title: l10n.addFolderPreviewTitle,
    message: l10n.addFolderPreviewBody(path),
    confirmLabel: l10n.addFolder,
    cancelLabel: l10n.commonCancel,
  );
  if (!confirmed || !context.mounted) return false;

  final added = await ref
      .read(foldersControllerProvider.notifier)
      .addPath(path);

  // Adding a folder stops and restarts monitoring so it is watched right away.
  if (added) {
    ref.read(monitoringControllerProvider.notifier).restart();
  }
  if (!context.mounted) return added;

  ref
      .read(notificationProvider.notifier)
      .show(
        added ? l10n.folderAdded : l10n.folderAlreadyWatched,
        type: added ? AppNotificationType.success : AppNotificationType.info,
      );
  return added;
}
