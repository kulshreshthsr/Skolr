import 'package:flutter/animation.dart';

// ---------------------------------------------------------------------------
// Motion v2.1 — Apple-style expressive + Material 3 named curves
//
// Philosophy: motion should feel ALIVE. Springs over linear curves.
// Subtle overshoot on entrances. Bouncy releases on press states.
//
// But: never gratuitous. Each animation should have a job —
// signal interactivity, draw the eye, soften a state change.
//
// v2.1 adds Material 3 named curves (`emphasized`, `decelerate`, `accelerate`)
// alongside the descriptive names (`expressive`, `enter`, `exit`).
// ---------------------------------------------------------------------------

abstract final class SkolrMotion {
  // ── DURATIONS ─────────────────────────────────────────────────────────────

  /// 120ms — icon flips, toggle states, color transitions
  static const Duration instant = Duration(milliseconds: 120);

  /// 180ms — quick feedback (tap response, ripple)
  static const Duration fast = Duration(milliseconds: 180);

  /// 280ms — most UI transitions (cards, modals, page elements)
  static const Duration base = Duration(milliseconds: 280);

  /// 420ms — page transitions, sheet entries
  static const Duration slow = Duration(milliseconds: 420);

  /// 600ms — splash, hero animations, empty-state illustrations
  static const Duration slower = Duration(milliseconds: 600);

  /// 900ms — counters, number tweens, onboarding setpieces
  static const Duration cinematic = Duration(milliseconds: 900);

  // ── CURVES — descriptive names ───────────────────────────────────────────

  /// Standard ease — neutral transitions
  static const Curve standard = Curves.easeInOut;

  /// Decelerate — elements entering from off-screen
  static const Curve enter = Curves.easeOutCubic;

  /// Strong decelerate — for big "drops into place" entrances
  static const Curve dropIn = Curves.easeOutExpo;

  /// Accelerate — elements leaving the screen
  static const Curve exit = Curves.easeInCubic;

  /// Expressive enter — slight overshoot. THE signature Apple curve.
  /// Equivalent to cubic-bezier(0.34, 1.56, 0.64, 1) (back-out).
  static const Curve expressive = _BackOut();

  /// Soft spring — gentle bounce for press releases
  static const Curve softSpring = _SoftSpring();

  /// Page transition curve — emphasized, dramatic
  static const Curve pageTransition = Curves.easeInOutCubicEmphasized;

  // ── CURVES — Material 3 named curves (aliases) ───────────────────────────
  // Match Material 3 naming so any widget using these names works without
  // remapping. These are the same curves as above, with the M3 names.

  /// M3 "emphasized" — the standard dramatic transition curve.
  /// Used for: page transitions, sliding thumbs, big state changes.
  /// Alias for [pageTransition].
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  /// M3 "emphasized decelerate" — strong deceleration on enter.
  /// Used for: elements appearing on screen.
  /// Alias for [enter].
  static const Curve emphasizedDecelerate = Curves.easeOutCubic;

  /// M3 "emphasized accelerate" — strong acceleration on exit.
  /// Used for: elements leaving the screen.
  /// Alias for [exit].
  static const Curve emphasizedAccelerate = Curves.easeInCubic;

  /// M3 "decelerate" — standard deceleration.
  /// Used for: gentle "settling" animations on enter.
  /// Alias for [enter].
  static const Curve decelerate = Curves.easeOutCubic;

  /// M3 "accelerate" — standard acceleration.
  /// Alias for [exit].
  static const Curve accelerate = Curves.easeInCubic;

  // ── SPRING DESCRIPTIONS ───────────────────────────────────────────────────
  // For use with SpringSimulation or AnimationController.fling()

  /// Tight spring — quick settle, slight overshoot.
  static final SpringDescription springTight =
      SpringDescription.withDampingRatio(
    mass: 1,
    stiffness: 500,
    ratio: 0.7,
  );

  /// Bouncy spring — playful, more overshoot. Use for delight moments.
  static final SpringDescription springBouncy =
      SpringDescription.withDampingRatio(
    mass: 1,
    stiffness: 400,
    ratio: 0.55,
  );

  /// Soft spring — gentle, calm settle. For non-attention-grabbing motion.
  static final SpringDescription springSoft =
      SpringDescription.withDampingRatio(
    mass: 1,
    stiffness: 200,
    ratio: 0.85,
  );

  // ── COMPOSED PAIRS ────────────────────────────────────────────────────────
  static const (Duration, Curve) cardEnter = (base, expressive);
  static const (Duration, Curve) cardPress = (instant, softSpring);
  static const (Duration, Curve) pagePush = (slow, pageTransition);
  static const (Duration, Curve) modalEnter = (slow, dropIn);
  static const (Duration, Curve) stateFlip = (fast, standard);
  static const (Duration, Curve) heroDrop = (slower, expressive);
  static const (Duration, Curve) counterTween = (cinematic, enter);

  // ── STAGGER ───────────────────────────────────────────────────────────────
  /// Default per-item delay for staggered list/grid entrances.
  static const Duration staggerStep = Duration(milliseconds: 60);
}

// ─── Custom curves ──────────────────────────────────────────────────────────

/// Back-out curve — Apple's signature "snap with overshoot".
/// Mirrors CSS cubic-bezier(0.34, 1.56, 0.64, 1).
class _BackOut extends Curve {
  const _BackOut();

  @override
  double transformInternal(double t) {
    const c1 = 1.70158;
    const c3 = c1 + 1;
    final tm1 = t - 1;
    return 1 + c3 * tm1 * tm1 * tm1 + c1 * tm1 * tm1;
  }
}

/// Soft spring — for press release. Tiny wobble, quick settle.
/// Uses Flutter's built-in elastic but with reduced amplitude.
class _SoftSpring extends Curve {
  const _SoftSpring();

  @override
  double transformInternal(double t) {
    // Quarter-amplitude elastic-out. Subtle bounce without being silly.
    if (t == 0 || t == 1) return t;
    final base = Curves.elasticOut.transform(t);
    // Blend toward linear to dampen the bounce
    return 0.7 * base + 0.3 * t;
  }
}