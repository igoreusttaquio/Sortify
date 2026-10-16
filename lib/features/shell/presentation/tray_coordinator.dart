import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tray_manager/tray_manager.dart' as tray;
import 'package:window_manager/window_manager.dart';

import '../../../core/router/app_router.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../folders/application/folders_controller.dart';
import '../../folders/application/monitoring_controller.dart';

/// Keeps the application alive in the system tray and mirrors the monitoring
/// state in the tray menu. If the platform has no tray support the widget is a
/// transparent pass-through.
class TrayCoordinator extends ConsumerStatefulWidget {
  const TrayCoordinator({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<TrayCoordinator> createState() => _TrayCoordinatorState();
}

class _TrayCoordinatorState extends ConsumerState<TrayCoordinator> {
  tray.TrayIcon? _icon;
  tray.Menu? _menu;
  tray.ListenerId? _trayListenerId;
  tray.MenuItem? _statusItem;
  tray.MenuItem? _pauseItem;

  final List<tray.MenuItem> _keepAlive = [];
  final _windowListener = _TrayWindowListener();

  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _setup());
  }

  @override
  void dispose() {
    windowManager.removeListener(_windowListener);
    if (_trayListenerId != null) _icon?.removeListener(_trayListenerId!);
    _icon?.dispose();
    _menu?.dispose();
    super.dispose();
  }

  Future<void> _setup() async {
    try {
      final icon = tray.TrayIcon.create();
      if (icon == null) return;
      _icon = icon;

      final image = tray.ImageAsset.fromAsset('assets/images/tray_icon.png');
      if (image != null) icon.icon = image;

      icon.setContextMenuTrigger(tray.ContextMenuTrigger.rightClicked);
      _trayListenerId = icon.addListener(_onTrayEvent);

      _buildMenu();
      icon.setVisible(true);

      _ready = true;
      await windowManager.setPreventClose(true);
      windowManager.addListener(_windowListener);
      _syncLabels();
    } catch (_) {
      // Tray unsupported on this platform; keep normal window behaviour.
      _ready = false;
    }
  }

  void _buildMenu() {
    final l10n = AppLocalizations.of(context);
    final menu = tray.Menu.create();
    if (menu == null) return;
    _menu = menu;

    tray.MenuItem? add(
      String label,
      VoidCallback onTap, {
      bool enabled = true,
    }) {
      final item = tray.MenuItem.createWithLabelAndType(
        label,
        tray.MenuItemType.normal,
      );
      if (item == null) return null;
      item.isEnabled = enabled;
      item.addListener((event) {
        if (event is tray.MenuItemClickedEvent) onTap();
      });
      menu.addItem(item);
      _keepAlive.add(item);
      return item;
    }

    _statusItem = add('Sortify', () {}, enabled: false);
    menu.addSeparator();
    add(l10n.trayOpen, _showWindow);
    _pauseItem = add(l10n.trayPause, _toggleMonitoring);
    add(l10n.trayRunAll, () {
      ref.read(monitoringControllerProvider.notifier).runAll();
    });
    add(l10n.traySettings, () {
      _showWindow();
      ref.read(routerProvider).go(AppRoutes.settings);
    });
    menu.addSeparator();
    add(l10n.trayQuit, _quit);

    _icon?.setContextMenu(menu);
  }

  void _syncLabels() {
    if (!_ready || !mounted) return;
    final l10n = AppLocalizations.of(context);
    final monitoring = ref.read(monitoringControllerProvider);
    final folderCount = ref.read(foldersControllerProvider).value?.length ?? 0;

    _statusItem?.label = monitoring.running
        ? '● ${l10n.trayMonitoring(folderCount)}'
        : '● ${l10n.statusPaused}';
    _pauseItem?.label = monitoring.running ? l10n.trayPause : l10n.trayResume;
  }

  void _toggleMonitoring() {
    ref.read(monitoringControllerProvider.notifier).toggle();
    _syncLabels();
  }

  void _onTrayEvent(tray.TrayIconEvent event) {
    if (event is tray.TrayIconClickedEvent ||
        event is tray.TrayIconDoubleClickedEvent) {
      _showWindow();
    }
  }

  Future<void> _showWindow() async {
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> _quit() async {
    await windowManager.setPreventClose(false);
    _icon?.dispose();
    _icon = null;
    await windowManager.destroy();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(monitoringControllerProvider, (_, _) => _syncLabels());
    ref.listen(foldersControllerProvider, (_, _) => _syncLabels());
    return widget.child;
  }
}

class _TrayWindowListener with WindowListener {
  @override
  void onWindowClose() async {
    await windowManager.hide();
  }
}
