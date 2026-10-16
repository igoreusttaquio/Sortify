import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_notification.dart';

/// Holds the stack of active notifications. Presentation lives in
/// `NotificationOverlay`; this only manages the list.
class NotificationController extends Notifier<List<AppNotification>> {
  int _seq = 0;

  @override
  List<AppNotification> build() => const [];

  String show(
    String message, {
    AppNotificationType type = AppNotificationType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 5),
  }) {
    final id = 'notification-${_seq++}';
    state = [
      ...state,
      AppNotification(
        id: id,
        message: message,
        type: type,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
      ),
    ];
    return id;
  }

  String success(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) => show(
    message,
    type: AppNotificationType.success,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  String error(String message) =>
      show(message, type: AppNotificationType.error);

  void dismiss(String id) {
    state = state.where((n) => n.id != id).toList();
  }
}

final notificationProvider =
    NotifierProvider<NotificationController, List<AppNotification>>(
      NotificationController.new,
    );
