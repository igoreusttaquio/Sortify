/// Spacing scale used across the product. Keeps rhythm consistent.
abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
  static const xxxl = 64.0;
}

/// Corner radii. The design system sits between 8 and 14.
abstract final class AppRadius {
  static const sm = 8.0;
  static const md = 10.0;
  static const lg = 12.0;
  static const xl = 14.0;
  static const pill = 999.0;
}

/// Shared motion tokens. Kept fast and subtle.
abstract final class AppMotion {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 200);
  static const slow = Duration(milliseconds: 250);
}

/// Fixed layout measurements for the desktop shell.
abstract final class AppLayout {
  static const sidebarWidth = 248.0;
  static const sidebarCollapsedWidth = 76.0;
  static const headerHeight = 56.0;
  static const contentMaxWidth = 1180.0;
  static const pagePadding = 28.0;
}
