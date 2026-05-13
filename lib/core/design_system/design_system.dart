import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_shadows.dart';

export 'app_colors.dart';
export 'app_motion.dart';
export 'app_radius.dart';
export 'app_shadows.dart';
export 'app_spacing.dart';
export 'app_theme.dart';
export 'app_typography.dart';

// ---------------------------------------------------------------------------
// SkolrGlass — the glass card recipe in one place.
//
// Use directly when you need a glass surface that isn't already wrapped by
// SkolrCard widget. Returns a BoxDecoration with:
//   • Gradient fill (subtle violet→blue tint, very low opacity)
//   • Violet-tinted 1px border
//   • Soft adaptive shadow
//
// On dark mode: layers on top of midnight surfaces (translucent feel).
// On light mode: layers on top of pale lavender bg (subtle violet wash).
// ---------------------------------------------------------------------------

abstract final class SkolrGlass {
  /// Default glass surface — for most cards.
  static BoxDecoration surface(
    BuildContext context, {
    BorderRadius? borderRadius,
    bool elevated = false,
  }) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return BoxDecoration(
      borderRadius: borderRadius ?? SkolrRadius.xl,
      gradient: isDark
          ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0x261A0F3D), // midnight @ 15%
                Color(0x141A0F3D), // midnight @ 8%
              ],
            )
          : const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFFAFAFF)],
            ),
      border: Border.all(
        color: isDark
            ? SkolrColors.glassBorder
            : SkolrColors.lightBorder,
        width: 1,
      ),
      boxShadow: elevated
          ? SkolrShadows.adaptiveMedium(brightness)
          : SkolrShadows.adaptiveSoft(brightness),
    );
  }

  /// Stronger glass — for emphasized cards (selected state, hero cards).
  static BoxDecoration emphasis(
    BuildContext context, {
    BorderRadius? borderRadius,
  }) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return BoxDecoration(
      borderRadius: borderRadius ?? SkolrRadius.xl,
      gradient: isDark
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                SkolrColors.primary.withValues(alpha: 0.18),
                SkolrColors.secondary.withValues(alpha: 0.10),
              ],
            )
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                SkolrColors.primary.withValues(alpha: 0.08),
                SkolrColors.secondary.withValues(alpha: 0.04),
              ],
            ),
      border: Border.all(
        color: SkolrColors.primary.withValues(alpha: isDark ? 0.4 : 0.3),
        width: 1.2,
      ),
      boxShadow: SkolrShadows.adaptiveMedium(brightness),
    );
  }

  /// Status-tinted glass — soft success/warning/danger surfaces.
  static BoxDecoration status(
    BuildContext context,
    Color color, {
    BorderRadius? borderRadius,
  }) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return BoxDecoration(
      borderRadius: borderRadius ?? SkolrRadius.xl,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withValues(alpha: isDark ? 0.15 : 0.10),
          color.withValues(alpha: isDark ? 0.06 : 0.04),
        ],
      ),
      border: Border.all(
        color: color.withValues(alpha: isDark ? 0.35 : 0.25),
        width: 1,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SkolrThemeController — global ThemeMode notifier.
//
// Wrap your app in MaterialApp with:
//   themeMode: SkolrThemeController.instance.mode,
//   theme: SkolrTheme.light(),
//   darkTheme: SkolrTheme.dark(),
// and listen via AnimatedBuilder(animation: SkolrThemeController.instance, ...)
//
// Persistence is handled by the Settings module (Wave 2); this controller
// only holds the live state.
// ---------------------------------------------------------------------------

class SkolrThemeController extends ChangeNotifier {
  SkolrThemeController._();
  static final SkolrThemeController instance = SkolrThemeController._();

  ThemeMode _mode = ThemeMode.dark; // dark is canonical
  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }

  void toggle() {
    setMode(_mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}