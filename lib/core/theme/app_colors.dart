import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';

// ---------------------------------------------------------------------------
// AppColors — LEGACY SHIM.
//
// This class is kept only for backwards compatibility with existing widgets
// that import `lib/core/theme/app_colors.dart`. All values delegate to the
// canonical SkolrColors / SkolrGradients in `design_system/`.
//
// New code should import from `design_system/design_system.dart` directly
// and use SkolrColors / SkolrGradients.
// ---------------------------------------------------------------------------

class AppColors {
  // Brand
  static const Color primary = SkolrColors.primary;
  static const Color primaryDark = SkolrColors.primaryPressed;
  static const Color secondary = SkolrColors.secondary;
  static const Color accent = SkolrColors.accent;

  // Surfaces
  static const Color background = SkolrColors.midnight800;
  static const Color backgroundLight = SkolrColors.lightBg;
  static const Color surface = SkolrColors.midnight700;
  static const Color surfaceLight = SkolrColors.lightSurface;
  static const Color white = Colors.white;

  // Text
  static const Color textPrimary = SkolrColors.textPrimaryDark;
  static const Color textPrimaryLight = SkolrColors.textPrimaryLight;
  static const Color textSecondary = SkolrColors.textSecondaryDark;
  static const Color textSecondaryLight = SkolrColors.textSecondaryLight;

  // Borders
  static const Color border = SkolrColors.glassBorder;
  static const Color borderLight = SkolrColors.lightBorder;

  // Status
  static const Color success = SkolrColors.success;
  static const Color warning = SkolrColors.warning;
  static const Color error = SkolrColors.danger;
  static const Color info = SkolrColors.info;
}