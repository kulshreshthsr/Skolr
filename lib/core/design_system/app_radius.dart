import 'package:flutter/painting.dart';

// ---------------------------------------------------------------------------
// Radius scale v2 — slightly more generous for premium feel.
//
// Premium UIs lean into rounder corners (16–24px on cards) — gives a softer,
// modern fintech vibe vs. the sharper 8–12px of "professional" apps.
//
// Glass cards use `xl` (20px) as the default to harmonise with the
// rounded square shape of the app icon itself.
// ---------------------------------------------------------------------------

abstract final class SkolrRadius {
  static const double smValue = 8;
  static const double mdValue = 12;
  static const double lgValue = 16;
  static const double xlValue = 20;
  static const double xxlValue = 28;
  static const double xxxlValue = 36;
  static const double fullValue = 999;

  static const BorderRadius sm = BorderRadius.all(Radius.circular(smValue));
  static const BorderRadius md = BorderRadius.all(Radius.circular(mdValue));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(lgValue));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(xlValue));
  static const BorderRadius xxl = BorderRadius.all(Radius.circular(xxlValue));
  static const BorderRadius xxxl = BorderRadius.all(Radius.circular(xxxlValue));
  static const BorderRadius full = BorderRadius.all(Radius.circular(fullValue));

  // Top-only — for bottom sheets / docked cards
  static const BorderRadius topLg = BorderRadius.vertical(
    top: Radius.circular(lgValue),
  );
  static const BorderRadius topXxl = BorderRadius.vertical(
    top: Radius.circular(xxlValue),
  );
  static const BorderRadius topXxxl = BorderRadius.vertical(
    top: Radius.circular(xxxlValue),
  );
}