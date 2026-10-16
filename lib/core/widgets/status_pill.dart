import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import 'animations.dart';

/// A small, tinted, bordered label. Used for monitoring status, rule state,
/// folder state and any other compact metadata.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.dot = false,
    this.pulse = false,
    this.dense = false,
  });

  final String label;
  final Color color;
  final IconData? icon;

  /// Show a leading dot instead of an icon. Dots can optionally pulse.
  final bool dot;
  final bool pulse;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: AppMotion.fast,
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(
        horizontal: dense ? AppSpacing.xs : AppSpacing.sm,
        vertical: dense ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            _PulsingDot(color: color, pulse: pulse),
            const SizedBox(width: 6),
          ] else if (icon != null) ...[
            AnimatedSwap(
              child: Icon(
                icon,
                key: ValueKey<IconData?>(icon),
                size: dense ? 12 : 13,
                color: color,
              ),
            ),
            const SizedBox(width: 5),
          ],
          AnimatedSwap(
            child: Text(
              label,
              key: ValueKey<String>(label),
              style: theme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: dense ? 11.5 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color, required this.pulse});

  final Color color;
  final bool pulse;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  @override
  void initState() {
    super.initState();
    if (widget.pulse) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _PulsingDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulse && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.pulse && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 8,
      height: 8,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (widget.pulse)
            ValueListenableBuilder<double>(
              valueListenable: _controller,
              builder: (context, value, child) => Container(
                width: 4 + value * 8,
                height: 4 + value * 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.25 * (1 - value)),
                ),
              ),
            ),
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
