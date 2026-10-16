import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/animations.dart';
import '../../../core/widgets/file_type_icon.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../folders/application/monitoring_controller.dart';
import '../../folders/presentation/folder_actions.dart';
import '../../rules/application/rule_builder_seed.dart';
import '../../rules/application/rule_editor_controller.dart';
import '../../rules/application/rules_controller.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../application/command_palette_controller.dart';

class _PaletteCommand {
  _PaletteCommand({
    required this.icon,
    required this.label,
    required this.group,
    required this.onRun,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String group;
  final String? subtitle;
  final void Function(BuildContext context) onRun;
}

class CommandPaletteOverlay extends ConsumerStatefulWidget {
  const CommandPaletteOverlay({super.key});

  @override
  ConsumerState<CommandPaletteOverlay> createState() =>
      _CommandPaletteOverlayState();
}

class _CommandPaletteOverlayState extends ConsumerState<CommandPaletteOverlay> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  int _selected = 0;
  String _query = '';

  /// Keeps the palette mounted briefly so the close animation can play out.
  bool _rendered = false;
  Timer? _closeTimer;

  @override
  void dispose() {
    _closeTimer?.cancel();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _close() {
    _textController.clear();
    _query = '';
    _selected = 0;
    ref.read(commandPaletteProvider.notifier).close();
  }

  void _run(_PaletteCommand command) {
    _close();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) command.onRun(context);
    });
  }

  List<_PaletteCommand> _buildCommands(AppLocalizations l10n) {
    final rules = ref.watch(rulesControllerProvider).value ?? const [];
    final unmatched = ref.watch(monitoringControllerProvider).unmatched;
    final monitoring = ref.watch(monitoringControllerProvider);
    final settings = ref.watch(settingsControllerProvider);

    return [
      _PaletteCommand(
        icon: Icons.bolt_outlined,
        label: l10n.paletteCreateRule,
        group: l10n.paletteCommands,
        onRun: (context) => ref.read(ruleEditorProvider.notifier).openNew(),
      ),
      _PaletteCommand(
        icon: Icons.create_new_folder_outlined,
        label: l10n.paletteAddFolder,
        group: l10n.paletteCommands,
        onRun: (context) => addWatchedFolderFlow(context, ref),
      ),
      _PaletteCommand(
        icon: Icons.play_circle_outline_rounded,
        label: l10n.paletteRunAll,
        group: l10n.paletteCommands,
        onRun: (context) =>
            ref.read(monitoringControllerProvider.notifier).runAll(),
      ),
      _PaletteCommand(
        icon: monitoring.running
            ? Icons.pause_circle_outline_rounded
            : Icons.play_circle_outline_rounded,
        label: monitoring.running ? l10n.palettePause : l10n.paletteResume,
        group: l10n.paletteCommands,
        onRun: (context) =>
            ref.read(monitoringControllerProvider.notifier).toggle(),
      ),
      _PaletteCommand(
        icon: Icons.dashboard_outlined,
        label: l10n.paletteGoDashboard,
        group: l10n.paletteCommands,
        onRun: (context) => context.go(AppRoutes.dashboard),
      ),
      _PaletteCommand(
        icon: Icons.bolt_outlined,
        label: l10n.paletteGoRules,
        group: l10n.paletteCommands,
        onRun: (context) => context.go(AppRoutes.rules),
      ),
      _PaletteCommand(
        icon: Icons.history_rounded,
        label: l10n.paletteGoActivity,
        group: l10n.paletteCommands,
        onRun: (context) => context.go(AppRoutes.activity),
      ),
      _PaletteCommand(
        icon: Icons.folder_outlined,
        label: l10n.paletteGoFolders,
        group: l10n.paletteCommands,
        onRun: (context) => context.go(AppRoutes.folders),
      ),
      _PaletteCommand(
        icon: Icons.settings_outlined,
        label: l10n.paletteOpenSettings,
        group: l10n.paletteCommands,
        onRun: (context) => context.go(AppRoutes.settings),
      ),
      _PaletteCommand(
        icon: Icons.contrast_rounded,
        label: l10n.paletteToggleTheme,
        group: l10n.paletteCommands,
        onRun: (context) => ref
            .read(settingsControllerProvider.notifier)
            .setTheme(
              settings.theme == AppThemePreference.light
                  ? AppThemePreference.dark
                  : AppThemePreference.light,
            ),
      ),
      for (final rule in rules)
        _PaletteCommand(
          icon: Icons.bolt_rounded,
          label: rule.name,
          subtitle: l10n.paletteRunRule,
          group: l10n.paletteRules,
          onRun: (context) =>
              ref.read(monitoringControllerProvider.notifier).applyRule(rule),
        ),
      for (final file in unmatched.take(20))
        _PaletteCommand(
          icon: FileTypeIcons.iconFor(file.path),
          label: file.fileName,
          subtitle: l10n.createRuleFromFile,
          group: l10n.paletteFiles,
          onRun: (context) {
            ref.read(ruleBuilderSeedProvider.notifier).seedFromFile(file.path);
            ref.read(ruleEditorProvider.notifier).openNew();
          },
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final visible = ref.watch(commandPaletteProvider);

    if (visible) {
      _closeTimer?.cancel();
      _closeTimer = null;
      _rendered = true;
    } else if (_rendered && _closeTimer == null) {
      _closeTimer = Timer(AppMotion.normal, () {
        if (!mounted) return;
        _closeTimer = null;
        setState(() => _rendered = false);
      });
    }

    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: AppMotion.normal,
        child: _rendered ? _buildPalette(context) : const SizedBox.expand(),
      ),
    );
  }

  Widget _buildPalette(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final l10n = AppLocalizations.of(context);

    final all = _buildCommands(l10n);
    final query = _query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? all
        : all
              .where(
                (c) =>
                    c.label.toLowerCase().contains(query) ||
                    (c.subtitle?.toLowerCase().contains(query) ?? false),
              )
              .toList();
    if (_selected >= filtered.length) {
      _selected = filtered.isEmpty ? 0 : filtered.length - 1;
    }

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _close,
            child: Container(color: Colors.black.withValues(alpha: 0.45)),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: AnimatedEntrance(
            scaleFrom: 0.97,
            slide: -0.02,
            child: Padding(
              padding: const EdgeInsets.only(top: 96),
              child: Material(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: 560,
                  constraints: const BoxConstraints(maxHeight: 460),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(color: semantic.subtleBorder),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildField(context, l10n),
                      Divider(height: 1, color: semantic.subtleBorder),
                      Flexible(
                        child: filtered.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(AppSpacing.xl),
                                child: Text(
                                  l10n.paletteNoResults,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              )
                            : _buildList(context, filtered),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: TextField(
        controller: _textController,
        focusNode: _focusNode,
        autofocus: true,
        onChanged: (value) => setState(() {
          _query = value;
          _selected = 0;
        }),
        onSubmitted: (_) {
          if (_selected >= 0) _run(_filteredSnapshot[_selected]);
        },
        onTapOutside: (_) => _focusNode.requestFocus(),
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: l10n.paletteSearchHint,
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        ),
      ),
    );
  }

  List<_PaletteCommand> _filteredSnapshot = const [];

  Widget _buildList(BuildContext context, List<_PaletteCommand> commands) {
    _filteredSnapshot = commands;
    final theme = Theme.of(context);

    final rows = <Widget>[];
    String? currentGroup;
    for (var i = 0; i < commands.length; i++) {
      final command = commands[i];
      if (command.group != currentGroup) {
        currentGroup = command.group;
        rows.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.xxs,
            ),
            child: Text(
              currentGroup,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 0.6,
              ),
            ),
          ),
        );
      }
      rows.add(
        _CommandRow(
          command: command,
          selected: i == _selected,
          onHover: () => setState(() => _selected = i),
          onTap: () => _run(command),
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      children: rows,
    );
  }
}

class _CommandRow extends StatefulWidget {
  const _CommandRow({
    required this.command,
    required this.selected,
    required this.onHover,
    required this.onTap,
  });

  final _PaletteCommand command;
  final bool selected;
  final VoidCallback onHover;
  final VoidCallback onTap;

  @override
  State<_CommandRow> createState() => _CommandRowState();
}

class _CommandRowState extends State<_CommandRow> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 1,
      ),
      child: MouseRegion(
        onEnter: (_) => widget.onHover(),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: PressableScale(
            pressedScale: 0.985,
            child: AnimatedContainer(
              duration: AppMotion.fast,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: widget.selected
                    ? theme.colorScheme.primary.withValues(alpha: 0.14)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.command.icon,
                    size: 18,
                    color: widget.selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      widget.command.label,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  if (widget.command.subtitle != null)
                    Text(
                      widget.command.subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
