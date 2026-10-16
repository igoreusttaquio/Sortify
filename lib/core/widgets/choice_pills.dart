import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';

class ChoiceOption<T> {
  const ChoiceOption({required this.value, required this.label, this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

/// A single, consistent single-select control used for filters, conflict
/// policies, theme selection and similar binary/multi options.
class ChoicePills<T> extends StatelessWidget {
  const ChoicePills({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.dense = false,
    this.scrollable = false,
  });

  final List<ChoiceOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;
  final bool dense;

  /// Lays the pills out in a single horizontally-scrollable row instead of
  /// wrapping onto multiple lines.
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final pills = [
      for (final option in options)
        _ChoicePill(
          label: option.label,
          icon: option.icon,
          selected: option.value == value,
          dense: dense,
          onTap: () => onChanged(option.value),
        ),
    ];

    if (scrollable) {
      return _HorizontalPillScroller(children: pills);
    }

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: pills,
    );
  }
}

/// Single-line, horizontally scrollable row of pills that reacts to the mouse
/// wheel, click-and-drag and a visible scrollbar.
class _HorizontalPillScroller extends StatefulWidget {
  const _HorizontalPillScroller({required this.children});

  final List<Widget> children;

  @override
  State<_HorizontalPillScroller> createState() =>
      _HorizontalPillScrollerState();
}

class _HorizontalPillScrollerState extends State<_HorizontalPillScroller> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    // Claim the signal so the vertical page scroll does not also react.
    GestureBinding.instance.pointerSignalResolver.register(event, (
      PointerSignalEvent resolved,
    ) {
      if (resolved is! PointerScrollEvent || !_controller.hasClients) return;
      final delta = resolved.scrollDelta.dy != 0
          ? resolved.scrollDelta.dy
          : resolved.scrollDelta.dx;
      if (delta == 0) return;
      _controller.jumpTo(
        (_controller.offset + delta)
            .clamp(0.0, _controller.position.maxScrollExtent)
            .toDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
      ),
      child: Listener(
        onPointerSignal: _onPointerSignal,
        child: Scrollbar(
          controller: _controller,
          thumbVisibility: true,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          child: SingleChildScrollView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                for (var i = 0; i < widget.children.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.xs),
                  widget.children[i],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoicePill extends StatefulWidget {
  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.dense,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final bool dense;
  final VoidCallback onTap;

  @override
  State<_ChoicePill> createState() => _ChoicePillState();
}

class _ChoicePillState extends State<_ChoicePill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final selected = widget.selected;

    final background = selected
        ? theme.colorScheme.primary.withValues(alpha: 0.16)
        : (_hovered ? semantic.hover : theme.colorScheme.surfaceContainer);
    final border = selected
        ? theme.colorScheme.primary.withValues(alpha: 0.5)
        : semantic.subtleBorder;
    final foreground = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: widget.dense ? AppSpacing.sm : AppSpacing.md,
            vertical: widget.dense ? 5 : AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 15, color: foreground),
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: foreground,
                  fontSize: widget.dense ? 12.5 : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
