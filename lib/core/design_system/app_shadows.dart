import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart' show Brightness;

import 'app_colors.dart';

// ---------------------------------------------------------------------------
// Shadow system v2 — premium depth
//
// Three layers of intent:
//   1. soft    — resting cards, list items
//   2. lifted  — elevated surfaces (sheets, FAB, dropdowns)
//   3. glow    — branded surfaces (primary CTAs, gradient cards) — uses
//                violet tint and larger blur for the "lit from within" effect
//
// Light mode uses cool indigo-tinted black (not pure black) — feels premium,
// less harsh than neutral shadow.
//
// Dark mode shadows are minimal (dark on dark is invisible) — but we
// keep `glow` strong because violet glow against black is the entire
// point of the design language.
// ---------------------------------------------------------------------------

abstract final class SkolrShadows {
  // ── LIGHT MODE ────────────────────────────────────────────────────────────

  /// Resting cards, list items. Barely there — 4% opacity, tight blur.
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x0A1E1B4B), // 4% indigo-black
      blurRadius: 12,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Hovered/pressed cards — slight lift.
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x141E1B4B), // 8%
      blurRadius: 20,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x081E1B4B), // 3% ambient
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  /// FABs, bottom sheets, dropdowns.
  static const List<BoxShadow> lifted = [
    BoxShadow(
      color: Color(0x1F1E1B4B), // 12%
      blurRadius: 32,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x0A1E1B4B), // 4% inner
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  // ── DARK MODE ─────────────────────────────────────────────────────────────

  /// Dark cards rely on borders, not shadows — these are token-level only.
  static const List<BoxShadow> softDark = [
    BoxShadow(
      color: Color(0x33000000), // 20% black
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> mediumDark = [
    BoxShadow(
      color: Color(0x4D000000), // 30% black
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> liftedDark = [
    BoxShadow(
      color: Color(0x66000000), // 40% black
      blurRadius: 40,
      offset: Offset(0, 16),
    ),
  ];

  // ── BRAND GLOW (works in both modes) ──────────────────────────────────────
  // Violet light bloom under primary CTAs. This is the signature effect.

  /// Subtle violet glow under primary buttons.
  static List<BoxShadow> brandGlowSoft = [
    BoxShadow(
      color: SkolrColors.primary.withValues(alpha: 0.35),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
  ];

  /// Strong violet glow — for hero buttons or featured elements.
  static List<BoxShadow> brandGlowStrong = [
    BoxShadow(
      color: SkolrColors.primary.withValues(alpha: 0.5),
      blurRadius: 40,
      offset: const Offset(0, 12),
      spreadRadius: -6,
    ),
    BoxShadow(
      color: SkolrColors.secondary.withValues(alpha: 0.25),
      blurRadius: 60,
      offset: const Offset(0, 20),
      spreadRadius: -10,
    ),
  ];

  /// Success glow — for confirmation moments.
  static List<BoxShadow> successGlow = [
    BoxShadow(
      color: SkolrColors.success.withValues(alpha: 0.4),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
  ];

  /// Danger glow — for destructive confirmations.
  static List<BoxShadow> dangerGlow = [
    BoxShadow(
      color: SkolrColors.danger.withValues(alpha: 0.4),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
  ];

  // ── ADAPTIVE HELPERS ──────────────────────────────────────────────────────

  static List<BoxShadow> adaptiveSoft(Brightness brightness) =>
      brightness == Brightness.dark ? softDark : soft;

  static List<BoxShadow> adaptiveMedium(Brightness brightness) =>
      brightness == Brightness.dark ? mediumDark : medium;

  static List<BoxShadow> adaptiveLifted(Brightness brightness) =>
      brightness == Brightness.dark ? liftedDark : lifted;
}