import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the navigation sidebar is collapsed to icon-only mode.
class SidebarController extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

final sidebarCollapsedProvider = NotifierProvider<SidebarController, bool>(
  SidebarController.new,
);
