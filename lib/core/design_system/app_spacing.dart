import 'package:flutter/widgets.dart';

// ---------------------------------------------------------------------------
// 4-point spacing grid. Token names preserved from v1 for backwards compat.
// ---------------------------------------------------------------------------

abstract final class SkolrSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
  static const double xxxxl = 64;

  // Page insets
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: xl,
  );
  static const EdgeInsets pageHorizontal = EdgeInsets.symmetric(
    horizontal: lg,
  );
  static const EdgeInsets pageVertical = EdgeInsets.symmetric(vertical: xl);

  // Card insets
  static const EdgeInsets cardPadding = EdgeInsets.all(xl);
  static const EdgeInsets cardPaddingMedium = EdgeInsets.all(lg);
  static const EdgeInsets cardPaddingSmall = EdgeInsets.all(md);

  // ListTile insets
  static const EdgeInsets tilePadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );
}

// SkolrGap — drop-in SizedBox for Column/Row spacing.
class SkolrGap extends StatelessWidget {
  const SkolrGap(this.size, {super.key});

  final double size;

  const SkolrGap.xs({super.key}) : size = SkolrSpacing.xs;
  const SkolrGap.sm({super.key}) : size = SkolrSpacing.sm;
  const SkolrGap.md({super.key}) : size = SkolrSpacing.md;
  const SkolrGap.lg({super.key}) : size = SkolrSpacing.lg;
  const SkolrGap.xl({super.key}) : size = SkolrSpacing.xl;
  const SkolrGap.xxl({super.key}) : size = SkolrSpacing.xxl;
  const SkolrGap.xxxl({super.key}) : size = SkolrSpacing.xxxl;

  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size);
}