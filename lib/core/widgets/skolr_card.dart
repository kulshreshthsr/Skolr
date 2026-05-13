import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/design_system.dart';

/// Card display variant.
enum SkolrCardVariant {
  /// 1px violet-tinted border, soft shadow. Default.
  flat,

  /// Stronger shadow + medium glass fill. Use for hero/featured cards.
  elevated,

  /// Tappable card — spring press scale, ink ripple, haptic feedback.
  interactive,

  /// Emphasis variant — violet wash fill, stronger border. Use for
  /// selected states, current-day callouts, "you are here" highlights.
  emphasis,
}

/// Skolr's primary container surface — glass card.
///
/// All variants use the SkolrGlass recipe under the hood:
///   • Subtle violet→blue gradient fill
///   • Violet-tinted 1px border (visible on dark, soft on light)
///   • Adaptive shadow
///
/// API kept backward-compatible with v1:
///   SkolrCard(child: ...)
///   SkolrCard(variant: SkolrCardVariant.interactive, onTap: () {}, child: ...)
class SkolrCard extends StatefulWidget {
  const SkolrCard({
    super.key,
    required this.child,
    this.variant = SkolrCardVariant.flat,
    this.padding,
    this.onTap,
    this.borderRadius,
    this.color,
    this.statusTint,
  }) : assert(
          variant != SkolrCardVariant.interactive || onTap != null,
          'SkolrCard.interactive requires an onTap callback.',
        );

  final Widget child;
  final SkolrCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  /// Override the default glass fill with a solid color. Rarely needed.
  final Color? color;

  /// If set, the card renders as a status-tinted glass (use SkolrColors.success
  /// / .warning / .danger). Overrides the default glass treatment.
  final Color? statusTint;

  @override
  State<SkolrCard> createState() => _SkolrCardState();
}

class _SkolrCardState extends State<SkolrCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: SkolrMotion.fast,
      reverseDuration: SkolrMotion.base,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _pressCtrl,
        curve: SkolrMotion.standard,
        reverseCurve: SkolrMotion.softSpring,
      ),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  bool get _interactive => widget.variant == SkolrCardVariant.interactive;

  void _onTapDown(_) {
    if (!_interactive) return;
    _pressCtrl.forward();
  }

  void _onTapUp(_) => _pressCtrl.reverse();
  void _onTapCancel() => _pressCtrl.reverse();

  void _onTap() {
    if (!_interactive) return;
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  BoxDecoration _decorationFor(BuildContext context) {
    final radius = widget.borderRadius ?? SkolrRadius.xl;

    if (widget.statusTint != null) {
      return SkolrGlass.status(context, widget.statusTint!,
          borderRadius: radius);
    }

    if (widget.color != null) {
      return BoxDecoration(
        color: widget.color,
        borderRadius: radius,
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? SkolrColors.glassBorder
              : SkolrColors.lightBorder,
        ),
      );
    }

    switch (widget.variant) {
      case SkolrCardVariant.elevated:
        return SkolrGlass.surface(
          context,
          borderRadius: radius,
          elevated: true,
        );
      case SkolrCardVariant.emphasis:
        return SkolrGlass.emphasis(context, borderRadius: radius);
      case SkolrCardVariant.flat:
      case SkolrCardVariant.interactive:
        return SkolrGlass.surface(context, borderRadius: radius);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final radius = widget.borderRadius ?? SkolrRadius.xl;

    Widget card = Container(
      decoration: _decorationFor(context),
      clipBehavior: Clip.antiAlias,
      child: widget.padding != null
          ? Padding(padding: widget.padding!, child: widget.child)
          : widget.child,
    );

    if (_interactive) {
      card = GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, child) =>
              Transform.scale(scale: _scale.value, child: child),
          child: Stack(
            children: [
              card,
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: radius,
                    onTap: _onTap,
                    splashColor: cs.primary.withValues(alpha: 0.10),
                    highlightColor: cs.primary.withValues(alpha: 0.05),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return card;
  }
}