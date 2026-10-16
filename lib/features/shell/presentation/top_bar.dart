import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/kbd_hint.dart';
import '../../../core/widgets/language_selector.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../command_palette/application/command_palette_controller.dart';
import '../../folders/application/monitoring_controller.dart';

class TopBar extends ConsumerWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final l10n = AppLocalizations.of(context);
    final monitoring = ref.watch(monitoringControllerProvider);

    return Container(
      height: AppLayout.headerHeight,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.85),
        border: Border(bottom: BorderSide(color: semantic.subtleBorder)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          const _Logo(),
          const SizedBox(width: AppSpacing.md),
          StatusPill(
            label: monitoring.running
                ? l10n.statusMonitoring
                : l10n.statusPaused,
            color: monitoring.running
                ? semantic.success
                : theme.colorScheme.onSurfaceVariant,
            dot: true,
            pulse: monitoring.running,
            dense: true,
          ),
          const Spacer(),
          _SearchButton(
            hint: l10n.search,
            onTap: () => ref.read(commandPaletteProvider.notifier).open(),
          ),
          const SizedBox(width: AppSpacing.xs),
          _TooltipIcon(
            message: l10n.help,
            icon: Icons.help_outline_rounded,
            onPressed: () => _showHelp(context),
          ),
          const LanguageSelectorButton(),
          _TooltipIcon(
            message: l10n.settings,
            icon: Icons.settings_outlined,
            onPressed: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.helpTitle),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Text(l10n.helpBody),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonClose),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Image.asset(
              'assets/images/app_icon.png',
              width: 30,
              height: 30,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          'Sortify',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

class _SearchButton extends StatefulWidget {
  const _SearchButton({required this.hint, required this.onTap});

  final String hint;
  final VoidCallback onTap;

  @override
  State<_SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<_SearchButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          width: 268,
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest.withValues(
              alpha: 0.4,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: _hovered
                  ? theme.colorScheme.primary.withValues(alpha: 0.5)
                  : semantic.subtleBorder,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 17,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  widget.hint,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const KbdHint(label: 'Ctrl K'),
            ],
          ),
        ),
      ),
    );
  }
}

class _TooltipIcon extends StatelessWidget {
  const _TooltipIcon({
    required this.message,
    required this.icon,
    required this.onPressed,
  });

  final String message;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: message,
      onPressed: onPressed,
      icon: Icon(icon, size: 19),
    );
  }
}
