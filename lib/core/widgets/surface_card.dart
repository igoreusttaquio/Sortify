import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';
import 'animations.dart';

/// A flat surface with a subtle border. The primary container of the UI.
///
/// Supports an optional [onTap], an animated hover highlight and a tactile
/// press scale.
class SurfaceCard extends StatefulWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.selected = false,
    this.borderColor,
    this.backgroundColor,
    this.radius = AppRadius.lg,
    this.hoverable = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool selected;
  final Color? borderColor;
  final Color? backgroundColor;
  final double radius;
  final bool hoverable;

  @override
  State<SurfaceCard> createState() => _SurfaceCardState();
}

class _SurfaceCardState extends State<SurfaceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final hovered = _hovered && widget.hoverable;

    final baseColor =
        widget.backgroundColor ?? theme.colorScheme.surfaceContainer;
    final background = hovered
        ? Color.alphaBlend(semantic.hover, baseColor)
        : baseColor;

    final border =
        widget.borderColor ??
        (widget.selected
            ? theme.colorScheme.primary.withValues(alpha: 0.6)
            : (hovered
                  ? theme.colorScheme.primary.withValues(alpha: 0.35)
                  : semantic.subtleBorder));

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(widget.radius),
      side: BorderSide(color: border),
    );

    final content = Padding(padding: widget.padding, child: widget.child);

    Widget card = AnimatedContainer(
      duration: AppMotion.fast,
      curve: Curves.easeOut,
      decoration: ShapeDecoration(color: background, shape: shape),
      child: widget.onTap == null
          ? content
          : Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(widget.radius),
                hoverColor: Colors.transparent,
                child: content,
              ),
            ),
    );

    if (widget.onTap != null) {
      card = PressableScale(child: card);
    }

    if (!widget.hoverable && widget.onTap == null) {
      return card;
    }

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: card,
    );
  }
}
