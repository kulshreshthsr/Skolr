import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// Skolr Typography v2 — Premium pairing
//
// FONT PAIRING:
//   Display & Headline → Plus Jakarta Sans (geometric, premium, used by
//     Vercel, Linear-adjacent products). Distinctive without being trendy.
//   Body & Label       → Inter (peerless readability at small sizes,
//     tabular figures available via fontFeatures).
//
// Why not Inter everywhere: Inter is excellent but ubiquitous. Pairing
// Plus Jakarta Sans for headlines gives Skolr its own voice while keeping
// body text rock-solid readable.
//
// SCALE:
//   Tightened from v1. Premium UIs use tighter tracking on large sizes
//   (-0.025em on display, -0.02em on headline) for that "expensive" feel.
//
// NUMERIC STYLES:
//   `metric` style uses tabular figures so numbers in stat cards align
//   perfectly across rows. Available via fontFeatures: [FontFeature.tabularFigures()].
//
// LINE HEIGHTS:
//   Display: 1.05  (very tight — confident hero moments)
//   Headline: 1.15 (tight)
//   Title: 1.3     (comfortable)
//   Body: 1.5      (relaxed reading)
//   Label: 1.2     (compact UI)
// ---------------------------------------------------------------------------

abstract final class SkolrTypography {
  // Scale tokens (logical pixels)
  static const double _display1 = 56;
  static const double _display2 = 44;
  static const double _headline1 = 32;
  static const double _headline2 = 26;
  static const double _title1 = 22;
  static const double _title2 = 18;
  static const double _title3 = 16;
  static const double _body1 = 16;
  static const double _body2 = 14;
  static const double _label1 = 14;
  static const double _label2 = 12;
  static const double _label3 = 11;

  static double _ls(double em, double fontSize) => em * fontSize;

  // ── Display font: Plus Jakarta Sans ───────────────────────────────────────
  static TextStyle _display({
    required double size,
    required FontWeight weight,
    required double height,
    required double letterSpacing,
    Color? color,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  // ── Body font: Inter ──────────────────────────────────────────────────────
  static TextStyle _body({
    required double size,
    required FontWeight weight,
    required double height,
    required double letterSpacing,
    Color? color,
    List<FontFeature>? features,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
      fontFeatures: features,
    );
  }

  // ── DISPLAY (Plus Jakarta Sans) ───────────────────────────────────────────

  /// 56 / extrabold / -0.025em — splash hero, onboarding peak moment
  static TextStyle displayLarge({Color? color}) => _display(
        size: _display1,
        weight: FontWeight.w800,
        height: 1.05,
        letterSpacing: _ls(-0.025, _display1),
        color: color,
      );

  /// 44 / bold / -0.025em
  static TextStyle displayMedium({Color? color}) => _display(
        size: _display2,
        weight: FontWeight.w700,
        height: 1.05,
        letterSpacing: _ls(-0.025, _display2),
        color: color,
      );

  // ── HEADLINE (Plus Jakarta Sans) ──────────────────────────────────────────

  /// 32 / bold / -0.02em — screen titles ("Welcome Back", "Settings")
  static TextStyle headlineLarge({Color? color}) => _display(
        size: _headline1,
        weight: FontWeight.w700,
        height: 1.1,
        letterSpacing: _ls(-0.02, _headline1),
        color: color,
      );

  /// 26 / semibold / -0.02em — section heroes
  static TextStyle headlineMedium({Color? color}) => _display(
        size: _headline2,
        weight: FontWeight.w600,
        height: 1.2,
        letterSpacing: _ls(-0.02, _headline2),
        color: color,
      );

  // ── TITLE (mix — Plus Jakarta for large, Inter for medium/small) ─────────

  /// 22 / semibold / -0.015em — card titles, list headers
  static TextStyle titleLarge({Color? color}) => _display(
        size: _title1,
        weight: FontWeight.w600,
        height: 1.25,
        letterSpacing: _ls(-0.015, _title1),
        color: color,
      );

  /// 18 / semibold / -0.01em — card secondary titles
  static TextStyle titleMedium({Color? color}) => _body(
        size: _title2,
        weight: FontWeight.w600,
        height: 1.3,
        letterSpacing: _ls(-0.01, _title2),
        color: color,
      );

  /// 16 / semibold / 0em — small sections, form section labels
  static TextStyle titleSmall({Color? color}) => _body(
        size: _title3,
        weight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0,
        color: color,
      );

  // ── BODY (Inter) ──────────────────────────────────────────────────────────

  /// 16 / regular / 0em — primary reading
  static TextStyle bodyLarge({Color? color}) => _body(
        size: _body1,
        weight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0,
        color: color,
      );

  /// 14 / regular / 0em — secondary body, list subtitles
  static TextStyle bodyMedium({Color? color}) => _body(
        size: _body2,
        weight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0,
        color: color,
      );

  /// 12 / regular / 0em — fine print
  static TextStyle bodySmall({Color? color}) => _body(
        size: _label2,
        weight: FontWeight.w400,
        height: 1.45,
        letterSpacing: 0,
        color: color,
      );

  // ── LABEL (Inter, increased tracking for legibility) ──────────────────────

  /// 14 / semibold / +0.02em — buttons, tabs, prominent labels
  static TextStyle labelLarge({Color? color}) => _body(
        size: _label1,
        weight: FontWeight.w600,
        height: 1.2,
        letterSpacing: _ls(0.02, _label1),
        color: color,
      );

  /// 12 / semibold / +0.04em — badges, captions
  static TextStyle labelMedium({Color? color}) => _body(
        size: _label2,
        weight: FontWeight.w600,
        height: 1.2,
        letterSpacing: _ls(0.04, _label2),
        color: color,
      );

  /// 11 / semibold / +0.08em — uppercase eyebrows, micro-labels
  /// Use with `.toUpperCase()` for the "section eyebrow" effect.
  static TextStyle labelSmall({Color? color}) => _body(
        size: _label3,
        weight: FontWeight.w700,
        height: 1.2,
        letterSpacing: _ls(0.08, _label3),
        color: color,
      );

  // ── METRIC (Plus Jakarta Sans, tabular figures) ───────────────────────────
  // Optimized for stat cards: tight tracking, tabular nums for column alignment.

  /// 40 / extrabold / -0.03em — hero stat number (e.g. "1,248")
  static TextStyle metricHero({Color? color}) => GoogleFonts.plusJakartaSans(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        height: 1.0,
        letterSpacing: _ls(-0.03, 40),
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// 28 / bold / -0.02em — dashboard stat number
  static TextStyle metricLarge({Color? color}) => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.05,
        letterSpacing: _ls(-0.02, 28),
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// 20 / bold / -0.01em — inline stat
  static TextStyle metricMedium({Color? color}) => GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: _ls(-0.01, 20),
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  // ── TextTheme ─────────────────────────────────────────────────────────────
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge(),
        displayMedium: displayMedium(),
        displaySmall: displayMedium(),
        headlineLarge: headlineLarge(),
        headlineMedium: headlineMedium(),
        headlineSmall: headlineMedium(),
        titleLarge: titleLarge(),
        titleMedium: titleMedium(),
        titleSmall: titleSmall(),
        bodyLarge: bodyLarge(),
        bodyMedium: bodyMedium(),
        bodySmall: bodySmall(),
        labelLarge: labelLarge(),
        labelMedium: labelMedium(),
        labelSmall: labelSmall(),
      );
}