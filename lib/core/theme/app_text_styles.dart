import 'package:flutter/material.dart';

import '../design_system/app_typography.dart';
import 'app_colors.dart';

// ---------------------------------------------------------------------------
// AppTextStyles — LEGACY SHIM.
//
// Delegates to SkolrTypography in `design_system/app_typography.dart`.
// New code should import SkolrTypography directly.
//
// NOTE: These are GETTERS (not const) because GoogleFonts.inter(...) is a
// runtime call. They CANNOT be used inside `const Text(...)` widgets.
//
// If you see "The invocation of 'heading' is not allowed in a constant
// expression", it's because the screen is using `const Text(..., style:
// AppTextStyles.heading)` — drop the `const` keyword from the Text widget.
// ---------------------------------------------------------------------------

class AppTextStyles {
  static TextStyle get heading =>
      SkolrTypography.headlineLarge(color: AppColors.textPrimary);

  static TextStyle get subheading =>
      SkolrTypography.bodyLarge(color: AppColors.textSecondary);

  static TextStyle get title =>
      SkolrTypography.titleLarge(color: AppColors.textPrimary);

  static TextStyle get buttonText =>
      SkolrTypography.labelLarge(color: Colors.white);

  static TextStyle get inputText =>
      SkolrTypography.bodyLarge(color: AppColors.textPrimary);

  static TextStyle get bodyLarge =>
      SkolrTypography.bodyLarge(color: AppColors.textPrimary);

  static TextStyle get bodyMedium =>
      SkolrTypography.bodyMedium(color: AppColors.textPrimary);

  static TextStyle get labelLarge =>
      SkolrTypography.labelLarge(color: AppColors.textPrimary);

  static TextStyle get labelMedium =>
      SkolrTypography.labelMedium(color: AppColors.textSecondary);

  static TextStyle get metricLarge =>
      SkolrTypography.metricLarge(color: AppColors.textPrimary);
}