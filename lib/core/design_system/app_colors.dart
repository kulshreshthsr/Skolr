import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Skolr Premium Brand Palette — v2.1 (logo-aligned, with token aliases)
//
// Brand DNA pulled directly from the app icon:
//   • Deep purple-black backdrop  →  midnight surface foundation
//   • Violet "S" curve            →  primary brand color  #8B5CF6
//   • Electric blue "S" curve     →  secondary accent     #3B82F6
//   • White graduation cap        →  high-contrast text
//
// Design ethos:
//   • Dark-first (the logo lives on darkness; light mode is a translation)
//   • Glass-over-gradient: deep gradient base, translucent surfaces stacked on top
//   • One brand gradient — used sparingly, always with the same direction (135°)
//   • Status colors restyled in muted-glass variants so they don't shout
//
// v2.1 adds container/avatar TOP-LEVEL aliases so widgets referencing
// e.g. `SkolrColors.primaryContainer` directly (not via ColorScheme) work.
//
// Contrast audit (WCAG):
//   • #FFFFFF on #0A0420 → 19.6 : 1   (AAA)
//   • #A5B0CF on #0A0420 →  8.9 : 1   (AAA — secondary text)
//   • #8B5CF6 on #0A0420 →  5.4 : 1   (AA  — primary accents)
// ---------------------------------------------------------------------------

abstract final class SkolrColors {
  // ── BRAND CORE ────────────────────────────────────────────────────────────
  /// Primary violet — the dominant brand hue. Pulled from the logo's "S" curve top.
  static const Color primary = Color(0xFF8B5CF6);
  static const Color primaryHover = Color(0xFF9D6FFF);
  static const Color primaryPressed = Color(0xFF7A4DEB);

  /// Secondary electric blue — paired with primary in the gradient.
  static const Color secondary = Color(0xFF3B82F6);
  static const Color secondaryHover = Color(0xFF5294FF);
  static const Color secondaryPressed = Color(0xFF2C6DD9);

  /// Accent magenta — used only for emphasis (top-of-funnel callouts, badges).
  static const Color accent = Color(0xFFD946EF);

  // ── MIDNIGHT SURFACE STACK (dark mode foundation) ────────────────────────
  /// Deepest layer — page background, the "void" behind everything.
  static const Color midnight900 = Color(0xFF06021A);

  /// Primary surface — most screens sit on this.
  static const Color midnight800 = Color(0xFF0A0420);

  /// Slightly elevated — section backgrounds, nav bars.
  static const Color midnight700 = Color(0xFF120A2E);

  /// Glass card base before opacity is applied.
  static const Color midnight600 = Color(0xFF1A0F3D);

  /// Elevated surface — modal/sheet backgrounds.
  static const Color midnight500 = Color(0xFF22154D);

  /// Royal violet — used in gradient endpoints, hover states.
  static const Color midnight400 = Color(0xFF2D1B66);

  // ── GLASS SYSTEM ──────────────────────────────────────────────────────────
  static const Color glassFillTop = Color(0x148B5CF6); // violet @ 8%
  static const Color glassFillBottom = Color(0x083B82F6); // blue @ 3%
  static const Color glassBorder = Color(0x2E8B5CF6); // violet @ 18%
  static const Color glassBorderStrong = Color(0x4D8B5CF6); // violet @ 30%
  static const Color glassHighlight = Color(0x1AFFFFFF); // white @ 10%

  // ── LIGHT MODE TRANSLATIONS ───────────────────────────────────────────────
  static const Color lightBg = Color(0xFFFAFAFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF4F2FF);
  static const Color lightBorder = Color(0xFFE6E1FF);
  static const Color lightBorderStrong = Color(0xFFCFC4FF);
  static const Color lightGlassFillTop = Color(0x0F8B5CF6); // violet @ 6%
  static const Color lightGlassFillBottom = Color(0x083B82F6); // blue @ 3%

  // ── TEXT ──────────────────────────────────────────────────────────────────
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFA5B0CF);
  static const Color textTertiaryDark = Color(0xFF6E7AA0);
  static const Color textDisabledDark = Color(0xFF3F476A);

  static const Color textPrimaryLight = Color(0xFF0A0420);
  static const Color textSecondaryLight = Color(0xFF52597A);
  static const Color textTertiaryLight = Color(0xFF8189A8);
  static const Color textDisabledLight = Color(0xFFB8BDD1);

  // ── STATUS COLORS ─────────────────────────────────────────────────────────
  static const Color success = Color(0xFF10D9A0);
  static const Color successSoft = Color(0x1A10D9A0);
  static const Color successStrong = Color(0xFF34F0BA);
  static const Color successOnLight = Color(0xFF059669);

  static const Color warning = Color(0xFFFFB547);
  static const Color warningSoft = Color(0x1AFFB547);
  static const Color warningStrong = Color(0xFFFFCB7A);
  static const Color warningOnLight = Color(0xFFD97706);

  static const Color danger = Color(0xFFFF5A6A);
  static const Color dangerSoft = Color(0x1AFF5A6A);
  static const Color dangerStrong = Color(0xFFFF7A88);
  static const Color dangerOnLight = Color(0xFFDC2626);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoSoft = Color(0x1A3B82F6);

  // ── CONTAINER ALIASES (top-level, for direct reference) ──────────────────
  // These mirror the ColorScheme container colors so widgets that reference
  // `SkolrColors.primaryContainer` directly (rather than via Theme.of(context)
  // .colorScheme.primaryContainer) keep working. Values match the `dark` scheme
  // since dark is canonical; for light mode use the ColorScheme directly.

  /// Deep violet container — for primary-tinted backgrounds.
  static const Color primaryContainer = Color(0xFF4C1D95);
  static const Color onPrimaryContainer = Color(0xFFE9D5FF);

  /// Deep blue container — for secondary-tinted backgrounds.
  static const Color secondaryContainer = Color(0xFF1E3A8A);
  static const Color onSecondaryContainer = Color(0xFFBFDBFE);

  /// Status containers — for success/warning/danger pills and chips.
  /// On dark mode these are deep-tone fills; foreground text is the pastel.
  static const Color successContainer = Color(0xFF064E3B);
  static const Color onSuccessContainer = Color(0xFF6EE7B7);

  static const Color warningContainer = Color(0xFF78350F);
  static const Color onWarningContainer = Color(0xFFFCD34D);

  static const Color dangerContainer = Color(0xFF7F1D1D);
  static const Color onDangerContainer = Color(0xFFFECACA);

  static const Color infoDark = Color(0xFF1E3A8A);
  static const Color onInfoDark = Color(0xFFBFDBFE);

  // ── AVATAR DIRECT-COLOR ALIASES ──────────────────────────────────────────
  // Older widgets reference these by name. Newer code should use
  // `SkolrColors.avatarFor(name)` which returns a deterministic pair.
  static const Color avatarInfoBg = Color(0xFF0E7490); // cyan-700
  static const Color avatarInfoFg = Color(0xFFA5F3FC); // cyan-100

  static const Color avatarVioletBg = Color(0xFF6D28D9); // violet-700
  static const Color avatarVioletFg = Color(0xFFE9D5FF); // violet-100

  static const Color avatarRoseBg = Color(0xFFBE185D); // pink-700
  static const Color avatarRoseFg = Color(0xFFFBCFE8); // pink-100

  static const Color avatarMintBg = Color(0xFF15803D); // emerald-700
  static const Color avatarMintFg = Color(0xFFBBF7D0); // emerald-100

  static const Color avatarOrangeBg = Color(0xFFC2410C); // orange-700
  static const Color avatarOrangeFg = Color(0xFFFED7AA); // orange-100

  static const Color avatarBlueBg = Color(0xFF1D4ED8); // blue-700
  static const Color avatarBlueFg = Color(0xFFBFDBFE); // blue-100

  // ── AVATAR PALETTE (initials backgrounds) ────────────────────────────────
  // Six hand-picked pairs that all play nicely with violet/blue brand.
  static const List<(Color bg, Color fg)> avatarPairs = [
    (avatarVioletBg, avatarVioletFg),
    (avatarBlueBg, avatarBlueFg),
    (avatarInfoBg, avatarInfoFg),
    (avatarRoseBg, avatarRoseFg),
    (avatarOrangeBg, avatarOrangeFg),
    (avatarMintBg, avatarMintFg),
  ];

  /// Returns a deterministic avatar color pair for a given seed string.
  static (Color, Color) avatarFor(String seed) {
    final hash = seed.codeUnits.fold<int>(0, (a, b) => a + b);
    return avatarPairs[hash % avatarPairs.length];
  }

  // ── COLOR SCHEMES ─────────────────────────────────────────────────────────
  // Dark scheme — the canonical Skolr look.
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: accent,
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF86198F),
    onTertiaryContainer: Color(0xFFFBCFE8),
    error: danger,
    onError: Color(0xFFFFFFFF),
    errorContainer: dangerContainer,
    onErrorContainer: onDangerContainer,
    surface: midnight800,
    onSurface: textPrimaryDark,
    surfaceContainerLowest: midnight900,
    surfaceContainerLow: midnight800,
    surfaceContainer: midnight700,
    surfaceContainerHigh: midnight600,
    surfaceContainerHighest: midnight500,
    onSurfaceVariant: textSecondaryDark,
    outline: Color(0xFF3F476A),
    outlineVariant: Color(0xFF2A2F4D),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: lightSurface,
    onInverseSurface: textPrimaryLight,
    inversePrimary: Color(0xFF7C3AED),
  );

  // Light scheme — same brand identity, flipped canvas.
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF7C3AED), // slightly deeper for AA contrast on white
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFEDE4FF),
    onPrimaryContainer: Color(0xFF2E1065),
    secondary: Color(0xFF2563EB),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFDBEAFE),
    onSecondaryContainer: Color(0xFF172554),
    tertiary: Color(0xFFA21CAF),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFAE8FF),
    onTertiaryContainer: Color(0xFF4A044E),
    error: dangerOnLight,
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF7F1D1D),
    surface: lightBg,
    onSurface: textPrimaryLight,
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: lightSurface,
    surfaceContainer: lightSurfaceAlt,
    surfaceContainerHigh: Color(0xFFEEEBFF),
    surfaceContainerHighest: Color(0xFFE6E1FF),
    onSurfaceVariant: textSecondaryLight,
    outline: lightBorderStrong,
    outlineVariant: lightBorder,
    shadow: Color(0xFF1E1B4B),
    scrim: Color(0xFF000000),
    inverseSurface: midnight800,
    onInverseSurface: textPrimaryDark,
    inversePrimary: primary,
  );
}

// ---------------------------------------------------------------------------
// SkolrGradients — the brand's signature visual element.
//
// Rule of thumb: at most ONE gradient surface per screen. Gradients are
// the seasoning, not the dish. Use them for:
//   • Primary CTAs
//   • The hero metric on dashboard
//   • Logo-adjacent moments (splash, onboarding header)
//   • Selection states (chip selected, nav indicator)
// Do NOT use gradients for: card backgrounds, list rows, generic surfaces.
// ---------------------------------------------------------------------------

abstract final class SkolrGradients {
  /// Signature brand gradient — violet → electric blue, 135°.
  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [SkolrColors.primary, SkolrColors.secondary],
  );

  /// Pressed-state brand gradient — slightly darker.
  static const LinearGradient brandPressed = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [SkolrColors.primaryPressed, SkolrColors.secondaryPressed],
  );

  /// Extended brand gradient with magenta pop — for hero/splash moment only.
  static const LinearGradient brandExtended = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [SkolrColors.accent, SkolrColors.primary, SkolrColors.secondary],
  );

  /// Page background gradient — deep midnight with a subtle violet glow.
  static const RadialGradient pageBackgroundDark = RadialGradient(
    center: Alignment(-0.6, -0.8),
    radius: 1.4,
    colors: [
      Color(0xFF1A0F3D),
      SkolrColors.midnight800,
      SkolrColors.midnight900,
    ],
    stops: [0.0, 0.55, 1.0],
  );

  /// Light-mode page background — pale violet wash with subtle glow.
  static const RadialGradient pageBackgroundLight = RadialGradient(
    center: Alignment(-0.6, -0.8),
    radius: 1.4,
    colors: [
      Color(0xFFEDE9FE),
      Color(0xFFF5F3FF),
      SkolrColors.lightBg,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Glass card fill — subtle violet→blue tint, very low opacity.
  static const LinearGradient glassFillDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [SkolrColors.glassFillTop, SkolrColors.glassFillBottom],
  );

  static const LinearGradient glassFillLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [SkolrColors.lightGlassFillTop, SkolrColors.lightGlassFillBottom],
  );

  /// Status soft fills — for cards/pills that need to feel "tinted".
  static const LinearGradient successSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x2610D9A0), Color(0x0810D9A0)],
  );

  static const LinearGradient warningSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x26FFB547), Color(0x08FFB547)],
  );

  static const LinearGradient dangerSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x26FF5A6A), Color(0x08FF5A6A)],
  );

  /// Returns the appropriate page background for the current brightness.
  static Gradient pageBackground(Brightness brightness) =>
      brightness == Brightness.dark ? pageBackgroundDark : pageBackgroundLight;

  static Gradient glassFill(Brightness brightness) =>
      brightness == Brightness.dark ? glassFillDark : glassFillLight;
}