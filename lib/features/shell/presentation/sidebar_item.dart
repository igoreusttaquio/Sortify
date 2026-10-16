import 'package:flutter/material.dart';

import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/animations.dart';

class SidebarItem extends StatefulWidget {
  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailing,
    this.dense = false,
    this.collapsed = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool dense;

  /// When true only the icon is shown, centered, with a tooltip.
  final bool collapsed;

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;

    final selected = widget.selected;
    final color = selected
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurfaceVariant;

    final item = AnimatedContainer(
      duration: AppMotion.fast,
      curve: Curves.easeOut,
      height: widget.dense ? 34 : 38,
      padding: widget.collapsed
          ? EdgeInsets.zero
          : EdgeInsets.only(left: AppSpacing.sm, right: AppSpacing.xs),
      decoration: BoxDecoration(
        color: selected
            ? theme.colorScheme.primary.withValues(alpha: 0.14)
            : (_hovered ? semantic.hover : Colors.transparent),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: widget.collapsed
          ? Center(
              child: Icon(
                widget.icon,
                size: 19,
                color: selected ? theme.colorScheme.primary : color,
              ),
            )
          : Row(
              children: [
                AnimatedContainer(
                  duration: AppMotion.fast,
                  width: 3,
                  height: 16,
                  margin: const EdgeInsets.only(right: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: selected
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                Icon(
                  widget.icon,
                  size: widget.dense ? 16 : 18,
                  color: selected ? theme.colorScheme.primary : color,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    widget.label,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: widget.dense ? 13 : 14,
                    ),
                  ),
                ),
                if (widget.trailing != null) widget.trailing!,
              ],
            ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: widget.dense ? 0.5 : 1,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: PressableScale(
            pressedScale: 0.985,
            child: widget.collapsed
                ? Tooltip(message: widget.label, child: item)
                : item,
          ),
        ),
      ),
    );
  }
}
