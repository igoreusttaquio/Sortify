import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Fades and slides a subtree into place the first time it is built.
///
/// Used for page content and for staggering lists: pass `delay` based on the
/// item index for a subtle cascade.
class AnimatedEntrance extends StatefulWidget {
  const AnimatedEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppMotion.slow,
    this.slide = 0.06,
    this.scaleFrom,
    this.fade = true,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Vertical slide distance as a fraction of the child's height.
  final double slide;
  final double? scaleFrom;
  final bool fade;

  @override
  State<AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<AnimatedEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      _timer = Timer(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    Widget child = widget.child;
    if (widget.fade) {
      child = FadeTransition(opacity: curved, child: child);
    }
    if (widget.slide != 0) {
      child = SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, widget.slide),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    }
    if (widget.scaleFrom != null) {
      child = ScaleTransition(
        scale: Tween<double>(begin: widget.scaleFrom, end: 1).animate(curved),
        child: child,
      );
    }
    return child;
  }
}

/// Adds a tactile press (and optional hover) scale to any child without
/// competing in the gesture arena, so it is safe around buttons and ink wells.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.pressedScale = 0.98,
    this.hoverScale = 1,
    this.duration = AppMotion.fast,
  });

  final Widget child;
  final double pressedScale;
  final double hoverScale;
  final Duration duration;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scale = _pressed
        ? widget.pressedScale
        : (_hovered ? widget.hoverScale : 1.0);
    return MouseRegion(
      onEnter: (_) {
        if (widget.hoverScale != 1) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (_hovered) setState(() => _hovered = false);
      },
      child: Listener(
        onPointerDown: (_) => setState(() => _pressed = true),
        onPointerUp: (_) => setState(() => _pressed = false),
        onPointerCancel: (_) => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: scale,
          duration: widget.duration,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Smoothly counts an integer up or down whenever [value] changes.
class AnimatedCount extends StatelessWidget {
  const AnimatedCount({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 650),
  });

  final int value;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animated, _) =>
          Text(animated.round().toString(), style: style),
    );
  }
}

/// A keyed cross-fade (with optional slide/scale) for swapping small widgets
/// such as icons or labels.
class AnimatedSwap extends StatelessWidget {
  const AnimatedSwap({
    super.key,
    required this.child,
    this.duration = AppMotion.normal,
    this.scale = true,
  });

  final Widget child;
  final Duration duration;
  final bool scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        Widget result = FadeTransition(opacity: animation, child: child);
        if (scale) {
          result = ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1).animate(animation),
            child: result,
          );
        }
        return result;
      },
      child: child,
    );
  }
}
