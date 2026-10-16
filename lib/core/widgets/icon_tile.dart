import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// A rounded, tinted container holding a single icon. The shared building
/// block for file icons, folder icons, rule icons and empty-state glyphs.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.icon,
    required this.color,
    this.size = 40,
    this.iconSize = 20,
    this.radius = AppRadius.md,
    this.outlined = true,
    this.gradient = false,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final double radius;
  final bool outlined;

  /// When true the tile is filled with a diagonal tint instead of a flat one.
  final bool gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.28),
                  color.withValues(alpha: 0.12),
                ],
              )
            : null,
        color: gradient ? null : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(radius),
        border: outlined
            ? Border.all(color: color.withValues(alpha: 0.24))
            : null,
      ),
      child: Icon(icon, size: iconSize, color: color),
    );
  }
}
