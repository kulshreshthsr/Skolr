import 'package:flutter/material.dart';

import '../design_system/design_system.dart';

/// Skeleton shape variant.
enum SkolrSkeletonVariant {
  /// Full-width horizontal bar. Use for text rows.
  line,

  /// Rectangular block. Use for cards, images, or arbitrary areas.
  block,

  /// Circle. Use for avatars and icon placeholders.
  circle,
}

/// Shimmer placeholder shown while content is loading.
///
/// Respects the system "Reduce Motion" accessibility setting —
/// when enabled, shows a static muted colour instead of the sweep.
///
/// Usage:
/// ```dart
/// // Text placeholder
/// SkolrSkeleton.line(width: 180)
///
/// // Card placeholder
/// SkolrSkeleton.block(height: 120)
///
/// // Avatar placeholder
/// SkolrSkeleton.circle(size: 40)
///
/// // Compose into a card skeleton
/// Column(children: [
///   SkolrSkeleton.circle(size: 40),
///   SkolrGap.sm(),
///   SkolrSkeleton.line(width: 140),
///   SkolrGap.xs(),
///   SkolrSkeleton.line(width: 80),
/// ])
/// ```
class SkolrSkeleton extends StatefulWidget {
  const SkolrSkeleton({
    super.key,
    this.variant = SkolrSkeletonVariant.block,
    this.width,
    this.height,
    this.borderRadius,
  });

  const SkolrSkeleton.line({
    super.key,
    this.width,
    double? height,
    this.borderRadius,
  })  : variant = SkolrSkeletonVariant.line,
        height = height ?? 14;

  const SkolrSkeleton.block({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  }) : variant = SkolrSkeletonVariant.block;

  const SkolrSkeleton.circle({
    super.key,
    double size = 40,
  })  : variant = SkolrSkeletonVariant.circle,
        width = size,
        height = size,
        borderRadius = null;

  final SkolrSkeletonVariant variant;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  State<SkolrSkeleton> createState() => _SkolrSkeletonState();
}

class _SkolrSkeletonState extends State<SkolrSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  BorderRadius get _radius => switch (widget.variant) {
        SkolrSkeletonVariant.circle => SkolrRadius.full,
        SkolrSkeletonVariant.line => SkolrRadius.full,
        SkolrSkeletonVariant.block =>
          widget.borderRadius ?? SkolrRadius.md,
      };

  double? get _resolvedHeight => switch (widget.variant) {
        SkolrSkeletonVariant.line => widget.height ?? 14,
        SkolrSkeletonVariant.circle => widget.height,
        SkolrSkeletonVariant.block => widget.height,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final baseColor = cs.surfaceContainerHigh;
    final shimmerColor = cs.surfaceContainerHighest;

    final shape = Container(
      width: widget.variant == SkolrSkeletonVariant.circle
          ? widget.width
          : widget.width,
      height: _resolvedHeight,
      decoration: BoxDecoration(
        // White as the mask target — ShaderMask replaces this with gradient
        color: Colors.white,
        borderRadius: _radius,
      ),
    );

    if (reduceMotion) {
      // Static muted block — no animation
      return Container(
        width: widget.variant == SkolrSkeletonVariant.circle
            ? widget.width
            : widget.width,
        height: _resolvedHeight,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: _radius,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Shimmer band sweeps left to right.
        // Alignment(-1,0) = left edge, Alignment(1,0) = right edge.
        // The band is 60% of the width and travels from -2 to +2.
        final t = _controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(-2 + t * 4, 0),
            end: Alignment(-0.5 + t * 4, 0),
            colors: [baseColor, shimmerColor, baseColor],
          ).createShader(bounds),
          child: child,
        );
      },
      child: shape,
    );
  }
}
