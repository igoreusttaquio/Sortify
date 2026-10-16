import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_semantic_colors.dart';
import 'app_tokens.dart';

/// Sortify is desktop-first: every clickable control uses the hand cursor,
/// unlike Material's default which only does so on the web.
const _clickCursor = WidgetStatePropertyAll<MouseCursor>(
  SystemMouseCursors.click,
);

/// Builds the Material 3 [ThemeData] for both brightness modes.
///
/// Material 3 is the structural layer; the palette and density are tuned so
/// the result reads as a modern desktop tool rather than a mobile app.
abstract final class AppTheme {
  static ThemeData get dark => _base(
    brightness: Brightness.dark,
    colorScheme: _darkScheme,
    semantic: AppSemanticColors.dark,
  );

  static ThemeData get light => _base(
    brightness: Brightness.light,
    colorScheme: _lightScheme,
    semantic: AppSemanticColors.light,
  );

  static const _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: Color(0xFF07142E),
    primaryContainer: Color(0xFF1D3B84),
    onPrimaryContainer: Color(0xFFD8E5FF),
    secondary: AppColors.accent,
    onSecondary: Color(0xFF2A1A00),
    secondaryContainer: Color(0xFF5A3A00),
    onSecondaryContainer: Color(0xFFFFE2B5),
    tertiary: Color(0xFF7DD3FC),
    onTertiary: Color(0xFF06283D),
    error: AppColors.error,
    onError: Color(0xFF3B0A0A),
    errorContainer: Color(0xFF7F1D1D),
    onErrorContainer: Color(0xFFFECACA),
    surface: AppColors.background,
    onSurface: AppColors.textPrimary,
    onSurfaceVariant: AppColors.textSecondary,
    surfaceContainerLowest: Color(0xFF080D17),
    surfaceContainerLow: Color(0xFF0F1728),
    surfaceContainer: AppColors.surface,
    surfaceContainerHigh: AppColors.surfaceElevated,
    surfaceContainerHighest: AppColors.surfaceHighest,
    outline: AppColors.border,
    outlineVariant: AppColors.borderSubtle,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.textPrimary,
    onInverseSurface: AppColors.background,
    inversePrimary: Color(0xFF1D4ED8),
  );

  static const _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.lightPrimary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFDCE7FF),
    onPrimaryContainer: Color(0xFF14265A),
    secondary: AppColors.lightAccent,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFFEF0D6),
    onSecondaryContainer: Color(0xFF5A3A00),
    tertiary: Color(0xFF0EA5E9),
    onTertiary: Colors.white,
    error: Color(0xFFDC2626),
    onError: Colors.white,
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF7F1D1D),
    surface: AppColors.lightBackground,
    onSurface: AppColors.lightTextPrimary,
    onSurfaceVariant: AppColors.lightTextSecondary,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFFBFCFE),
    surfaceContainer: AppColors.lightSurface,
    surfaceContainerHigh: AppColors.lightSurfaceElevated,
    surfaceContainerHighest: AppColors.lightSurfaceHighest,
    outline: AppColors.lightBorder,
    outlineVariant: AppColors.lightBorderSubtle,
    shadow: Color(0x14202C46),
    scrim: Colors.black,
    inverseSurface: Color(0xFF1B2438),
    onInverseSurface: Color(0xFFF4F6FB),
    inversePrimary: Color(0xFF93C5FD),
  );

  static ThemeData _base({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required AppSemanticColors semantic,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      extensions: [semantic],
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, colorScheme.onSurface),
      dividerTheme: DividerThemeData(
        color: semantic.subtleBorder.withValues(alpha: 0.6),
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: AppLayout.headerHeight,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: semantic.subtleBorder),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          side: BorderSide(color: semantic.subtleBorder),
        ),
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: base.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 12,
        mouseCursor: _clickCursor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: semantic.subtleBorder),
        ),
        textStyle: base.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(
            colorScheme.surfaceContainerHigh,
          ),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              side: BorderSide(color: semantic.subtleBorder),
            ),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.onSurface.withValues(
            alpha: 0.08,
          ),
          disabledForegroundColor: colorScheme.onSurface.withValues(
            alpha: 0.38,
          ),
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ).copyWith(mouseCursor: _clickCursor),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          side: BorderSide(color: semantic.subtleBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ).copyWith(mouseCursor: _clickCursor),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ).copyWith(mouseCursor: _clickCursor),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
          highlightColor: semantic.hover,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ).copyWith(mouseCursor: _clickCursor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest.withValues(alpha: 0.4),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        iconColor: colorScheme.onSurfaceVariant,
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        border: _inputBorder(semantic.subtleBorder),
        enabledBorder: _inputBorder(semantic.subtleBorder),
        focusedBorder: _inputBorder(colorScheme.primary, width: 1.5),
        errorBorder: _inputBorder(colorScheme.error),
        focusedErrorBorder: _inputBorder(colorScheme.error, width: 1.5),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        side: BorderSide(color: semantic.subtleBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        labelStyle: base.textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: 2,
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: semantic.sidebar,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.16),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        selectedIconTheme: IconThemeData(color: colorScheme.primary, size: 20),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurfaceVariant,
          size: 20,
        ),
        selectedLabelTextStyle: base.textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: base.textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
        mouseCursor: _clickCursor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 2,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.surfaceContainerHigh,
        contentTextStyle: base.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: semantic.subtleBorder),
        ),
        elevation: 8,
        insetPadding: const EdgeInsets.all(AppSpacing.md),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: semantic.subtleBorder),
        ),
        textStyle: base.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface,
        ),
        waitDuration: const Duration(milliseconds: 500),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(
          colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
        ),
        thickness: const WidgetStatePropertyAll(8),
        radius: const Radius.circular(AppRadius.sm),
        crossAxisMargin: 2,
      ),
      switchTheme: SwitchThemeData(
        mouseCursor: _clickCursor,
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.16),
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.onSurface.withValues(alpha: 0.08),
        circularTrackColor: colorScheme.onSurface.withValues(alpha: 0.08),
      ),
      sliderTheme: SliderThemeData(
        mouseCursor: _clickCursor,
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.onSurface.withValues(alpha: 0.12),
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.12),
        trackHeight: 4,
        valueIndicatorColor: colorScheme.surfaceContainerHighest,
        valueIndicatorTextStyle: TextStyle(color: colorScheme.onSurface),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withValues(alpha: 0.3),
        selectionHandleColor: colorScheme.primary,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.onSurface,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        dividerColor: semantic.subtleBorder,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static TextTheme _textTheme(TextTheme base, Color onSurface) {
    return base
        .copyWith(
          headlineMedium: base.headlineMedium?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          headlineSmall: base.headlineSmall?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
          titleLarge: base.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: base.titleMedium?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: base.titleSmall?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: base.bodyLarge?.copyWith(fontSize: 15, height: 1.45),
          bodyMedium: base.bodyMedium?.copyWith(fontSize: 14, height: 1.45),
          bodySmall: base.bodySmall?.copyWith(fontSize: 12.5, height: 1.4),
          labelLarge: base.labelLarge?.copyWith(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
          labelMedium: base.labelMedium?.copyWith(fontSize: 12),
        )
        .apply(bodyColor: onSurface, displayColor: onSurface);
  }
}
