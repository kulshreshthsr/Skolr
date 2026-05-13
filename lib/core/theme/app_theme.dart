import 'package:flutter/material.dart';

import '../design_system/app_theme.dart';

// ---------------------------------------------------------------------------
// AppTheme — LEGACY SHIM.
//
// Delegates to SkolrTheme. Keeps the existing `AppTheme.lightTheme` static
// working so any existing `theme: AppTheme.lightTheme` in MaterialApp keeps
// rendering. Also exposes `darkTheme` so you can wire both modes:
//
//   MaterialApp(
//     theme: AppTheme.lightTheme,
//     darkTheme: AppTheme.darkTheme,
//     themeMode: SkolrThemeController.instance.mode,
//   )
// ---------------------------------------------------------------------------

class AppTheme {
  static ThemeData get lightTheme => SkolrTheme.light();
  static ThemeData get darkTheme => SkolrTheme.dark();
}