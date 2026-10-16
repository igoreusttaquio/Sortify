import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../application/rule_editor_controller.dart';
import 'rule_editor_panel.dart';

/// Hosts the rule editor as a right-side sliding panel instead of a page.
class RuleEditorOverlay extends ConsumerStatefulWidget {
  const RuleEditorOverlay({super.key});

  @override
  ConsumerState<RuleEditorOverlay> createState() => _RuleEditorOverlayState();
}

class _RuleEditorOverlayState extends ConsumerState<RuleEditorOverlay> {
  static const _preferredWidth = 480.0;

  bool _rendered = false;
  Timer? _closeTimer;
  RuleEditorRequest? _lastRequest;

  @override
  void dispose() {
    _closeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = ref.watch(ruleEditorProvider);
    final visible = request != null;

    if (visible) {
      _lastRequest = request;
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

    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final width = math.min(
      _preferredWidth,
      MediaQuery.sizeOf(context).width - AppSpacing.xl,
    );

    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: AppMotion.normal,
        child: _rendered && _lastRequest != null
            ? Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () =>
                          ref.read(ruleEditorProvider.notifier).close(),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedSlide(
                        offset: visible ? Offset.zero : const Offset(1, 0),
                        duration: AppMotion.normal,
                        curve: Curves.easeOutCubic,
                        child: SizedBox(
                          width: width,
                          child: Material(
                            color: theme.colorScheme.surfaceContainerHigh,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: semantic.subtleBorder,
                                  ),
                                ),
                              ),
                              child: RuleEditorPanel(
                                key: ValueKey<int>(_lastRequest!.token),
                                ruleId: _lastRequest!.ruleId,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.expand(),
      ),
    );
  }
}
