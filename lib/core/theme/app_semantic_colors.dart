import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic colors that Material's [ColorScheme] does not model directly.
///
/// Access through `Theme.of(context).extension<AppSemanticColors>()!` or the
/// [AppSemanticColorsX] helper.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.onSuccess,
    required this.onWarning,
    required this.subtleBorder,
    required this.sidebar,
    required this.hover,
  });

  final Color success;
  final Color warning;
  final Color onSuccess;
  final Color onWarning;
  final Color subtleBorder;
  final Color sidebar;
  final Color hover;

  static const dark = AppSemanticColors(
    success: AppColors.success,
    warning: AppColors.warning,
    onSuccess: Color(0xFF06281C),
    onWarning: Color(0xFF2A1A00),
    subtleBorder: AppColors.border,
    sidebar: AppColors.sidebar,
    hover: Color(0x14FFFFFF),
  );

  static const light = AppSemanticColors(
    success: Color(0xFF16A34A),
    warning: Color(0xFFD97706),
    onSuccess: Colors.white,
    onWarning: Colors.white,
    subtleBorder: AppColors.lightBorder,
    sidebar: AppColors.lightSurface,
    hover: Color(0x0A000000),
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? onSuccess,
    Color? onWarning,
    Color? subtleBorder,
    Color? sidebar,
    Color? hover,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      onSuccess: onSuccess ?? this.onSuccess,
      onWarning: onWarning ?? this.onWarning,
      subtleBorder: subtleBorder ?? this.subtleBorder,
      sidebar: sidebar ?? this.sidebar,
      hover: hover ?? this.hover,
    );
  }

  @override
  AppSemanticColors lerp(
    covariant ThemeExtension<AppSemanticColors>? other,
    double t,
  ) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      subtleBorder: Color.lerp(subtleBorder, other.subtleBorder, t)!,
      sidebar: Color.lerp(sidebar, other.sidebar, t)!,
      hover: Color.lerp(hover, other.hover, t)!,
    );
  }
}

extension AppSemanticColorsX on BuildContext {
  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>() ?? AppSemanticColors.dark;
}
