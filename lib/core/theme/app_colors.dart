import 'package:flutter/material.dart';

/// Central palette for Sortify.
///
/// Widgets must never hardcode colors: they read from the active
/// [ColorScheme] or from [AppSemanticColors] via the theme.
abstract final class AppColors {
  // --- Dark (navy, blue, orange) ---
  static const background = Color(0xFF0B1220);
  static const surface = Color(0xFF141D30);
  static const surfaceElevated = Color(0xFF1B263C);
  static const surfaceHighest = Color(0xFF243149);
  static const sidebar = Color(0xFF0D1526);
  static const primary = Color(0xFF4F8CFF);
  static const accent = Color(0xFFF5A524);
  static const textPrimary = Color(0xFFE8EEF9);
  static const textSecondary = Color(0xFF97A6C0);
  static const border = Color(0xFF2B3952);
  static const borderSubtle = Color(0xFF1E2A40);
  static const success = Color(0xFF34D399);
  static const warning = Color(0xFFF5A524);
  static const error = Color(0xFFF87171);

  // Identity hues used by file-type icons and accents.
  static const purple = Color(0xFFB39DFF);
  static const indigo = Color(0xFF7C8CFF);
  static const pink = Color(0xFFF472B6);
  static const teal = Color(0xFF2DD4BF);
  static const cyan = Color(0xFF38BDF8);

  // --- Light (soft blue-grey, deeper blue, amber) ---
  static const lightBackground = Color(0xFFF4F6FB);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceElevated = Color(0xFFEEF2F9);
  static const lightSurfaceHighest = Color(0xFFE4EAF4);
  static const lightTextPrimary = Color(0xFF111A2E);
  static const lightTextSecondary = Color(0xFF55637C);
  static const lightBorder = Color(0xFFD3DBE8);
  static const lightBorderSubtle = Color(0xFFE6EBF3);
  static const lightPrimary = Color(0xFF2563EB);
  static const lightAccent = Color(0xFFD97706);
}
