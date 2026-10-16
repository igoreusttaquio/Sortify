import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/activity/presentation/activity_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/folders/presentation/folders_page.dart';
import '../../features/rules/presentation/rules_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/shell/presentation/app_shell.dart';

abstract final class AppRoutes {
  static const dashboard = '/dashboard';
  static const rules = '/rules';
  static const activity = '/activity';
  static const folders = '/folders';
  static const settings = '/settings';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.rules,
            builder: (context, state) => const RulesPage(),
          ),
          GoRoute(
            path: AppRoutes.activity,
            builder: (context, state) => const ActivityPage(),
          ),
          GoRoute(
            path: AppRoutes.folders,
            builder: (context, state) => const FoldersPage(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        _NotFoundScreen(message: state.error.toString()),
  );
});

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(message)));
  }
}
