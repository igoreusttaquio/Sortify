import 'package:flutter/foundation.dart';

enum AppNotificationType { success, error, info }

/// A transient message shown in the top-right corner of the window.
@immutable
class AppNotification {
  const AppNotification({
    required this.id,
    required this.message,
    required this.type,
    this.actionLabel,
    this.onAction,
    this.duration = const Duration(seconds: 5),
  });

  final String id;
  final String message;
  final AppNotificationType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration duration;

  bool get hasAction => actionLabel != null && onAction != null;
}
