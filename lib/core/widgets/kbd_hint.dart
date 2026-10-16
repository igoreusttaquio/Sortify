import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';

/// A small "keycap" hint such as `Ctrl K`.
class KbdHint extends StatelessWidget {
  const KbdHint({super.key, required this.label, this.size = 10.5});

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: semantic.subtleBorder),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: size,
          height: 1.2,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
