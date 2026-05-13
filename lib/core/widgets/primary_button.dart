import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/design_system.dart';

// ---------------------------------------------------------------------------
// PrimaryButton — Skolr's signature CTA.
//
// Visual recipe:
//   • Violet → electric blue gradient fill (135°)
//   • Soft violet bloom shadow (the "lit from within" effect)
//   • Spring scale on press (0.96, soft spring release)
//   • Glow intensifies on press
//   • Optional leading/trailing icon
//   • Optional loading state with inline spinner
//
// Variants:
//   • PrimaryButton          — gradient (default)
//   • PrimaryButton.secondary — outlined glass (transparent fill, glass border)
//   • PrimaryButton.tertiary  — flat text-only with subtle hover
//
// API kept backward-compatible with the old PrimaryButton:
//   PrimaryButton(text: 'Save', onPressed: () { })
// still works exactly as before.
// ---------------------------------------------------------------------------

enum _ButtonVariant { primary, secondary, tertiary }

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expand = true,
    this.height = 56,
  }) : _variant = _ButtonVariant.primary;

  /// Outlined glass variant — same shape, transparent fill, violet border.
  /// Use as the secondary action paired with a primary button.
  const PrimaryButton.secondary({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expand = true,
    this.height = 56,
  }) : _variant = _ButtonVariant.secondary;

  /// Flat text-only variant — for tertiary actions ("Cancel", "Skip").
  const PrimaryButton.tertiary({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expand = false,
    this.height = 48,
  }) : _variant = _ButtonVariant.tertiary;

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool loading;
  final bool expand;
  final double height;
  final _ButtonVariant _variant;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  bool get _enabled => widget.onPressed != null && !widget.loading;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: SkolrMotion.fast,
      reverseDuration: SkolrMotion.base,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
        parent: _pressCtrl,
        curve: SkolrMotion.standard,
        reverseCurve: SkolrMotion.softSpring,
      ),
    );
    _glow = Tween<double>(begin: 1.0, end: 1.6).animate(
      CurvedAnimation(parent: _pressCtrl, curve: SkolrMotion.standard),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    if (!_enabled) return;
    _pressCtrl.forward();
  }

  void _onTapUp(_) => _pressCtrl.reverse();
  void _onTapCancel() => _pressCtrl.reverse();

  void _onTap() {
    if (!_enabled) return;
    HapticFeedback.lightImpact();
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _pressCtrl,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: child,
          );
        },
        child: _buildSurface(isDark),
      ),
    );
  }

  Widget _buildSurface(bool isDark) {
    switch (widget._variant) {
      case _ButtonVariant.primary:
        return _primarySurface(isDark);
      case _ButtonVariant.secondary:
        return _secondarySurface(isDark);
      case _ButtonVariant.tertiary:
        return _tertiarySurface(isDark);
    }
  }

  // ── Primary: gradient + glow ────────────────────────────────────────────
  Widget _primarySurface(bool isDark) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, _) {
        return Container(
          width: widget.expand ? double.infinity : null,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: _enabled
                ? SkolrGradients.brand
                : LinearGradient(
                    colors: [
                      SkolrColors.primary.withValues(alpha: 0.4),
                      SkolrColors.secondary.withValues(alpha: 0.4),
                    ],
                  ),
            borderRadius: SkolrRadius.lg,
            boxShadow: _enabled
                ? [
                    BoxShadow(
                      color: SkolrColors.primary
                          .withValues(alpha: 0.35 * _glow.value.clamp(0, 1.6) / 1.6),
                      blurRadius: 24 * _glow.value,
                      offset: Offset(0, 8 * _glow.value),
                      spreadRadius: -4,
                    ),
                  ]
                : null,
          ),
          child: _content(Colors.white),
        );
      },
    );
  }

  // ── Secondary: outlined glass ────────────────────────────────────────────
  Widget _secondarySurface(bool isDark) {
    return Container(
      width: widget.expand ? double.infinity : null,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0x148B5CF6),
                  Color(0x083B82F6),
                ],
              )
            : null,
        color: isDark ? null : Colors.white,
        borderRadius: SkolrRadius.lg,
        border: Border.all(
          color: _enabled
              ? (isDark
                  ? SkolrColors.glassBorderStrong
                  : SkolrColors.lightBorderStrong)
              : (isDark
                  ? SkolrColors.glassBorder
                  : SkolrColors.lightBorder),
          width: 1.2,
        ),
      ),
      child: _content(
        isDark ? SkolrColors.textPrimaryDark : SkolrColors.textPrimaryLight,
      ),
    );
  }

  // ── Tertiary: flat text ──────────────────────────────────────────────────
  Widget _tertiarySurface(bool isDark) {
    return Container(
      width: widget.expand ? double.infinity : null,
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: SkolrSpacing.lg),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: SkolrRadius.md,
      ),
      child: _content(
        isDark ? SkolrColors.primary : SkolrColors.primary,
      ),
    );
  }

  // ── Content (icon + text + spinner) ──────────────────────────────────────
  Widget _content(Color fg) {
    if (widget.loading) {
      return Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            valueColor: AlwaysStoppedAnimation(fg),
          ),
        ),
      );
    }

    final children = <Widget>[];
    if (widget.icon != null) {
      children.add(Icon(widget.icon, size: 20, color: fg));
      children.add(const SkolrGap.sm());
    }
    children.add(
      Flexible(
        child: Text(
          widget.text,
          style: SkolrTypography.labelLarge(color: fg)
              .copyWith(fontSize: 15, fontWeight: FontWeight.w700),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    if (widget.trailingIcon != null) {
      children.add(const SkolrGap.sm());
      children.add(Icon(widget.trailingIcon, size: 20, color: fg));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SkolrSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
        children: children,
      ),
    );
  }
}