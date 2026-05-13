import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/design_system.dart';

/// Button variant — controls color palette.
enum SkolrButtonVariant { primary, secondary, tertiary, destructive }

/// Size — controls height, padding, and font size.
enum SkolrSize { sm, md, lg }

/// Skolr's primary interactive control.
///
/// Usage:
/// ```dart
/// SkolrButton(
///   label: 'Save Student',
///   onPressed: _save,
/// )
///
/// SkolrButton(
///   label: 'Delete',
///   variant: SkolrButtonVariant.destructive,
///   size: SkolrSize.sm,
///   isLoading: _deleting,
///   onPressed: _delete,
/// )
/// ```
class SkolrButton extends StatefulWidget {
  const SkolrButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = SkolrButtonVariant.primary,
    this.size = SkolrSize.md,
    this.isLoading = false,
    this.fullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final SkolrButtonVariant variant;
  final SkolrSize size;
  final bool isLoading;
  final bool fullWidth;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  bool get _disabled => onPressed == null && !isLoading;

  @override
  State<SkolrButton> createState() => _SkolrButtonState();
}

class _SkolrButtonState extends State<SkolrButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: SkolrMotion.fast,
      lowerBound: 0,
      upperBound: 1,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressController, curve: SkolrMotion.standard),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(_) {
    if (widget._disabled || widget.isLoading) return;
    _pressController.forward();
  }

  void _handleTapUp(_) => _pressController.reverse();
  void _handleTapCancel() => _pressController.reverse();

  void _handleTap() {
    if (widget._disabled || widget.isLoading) return;
    HapticFeedback.lightImpact();
    widget.onPressed?.call();
  }

  // ── Geometry ────────────────────────────────────────────────────────────

  double get _height => switch (widget.size) {
        SkolrSize.sm => 36,
        SkolrSize.md => 48,
        SkolrSize.lg => 56,
      };

  EdgeInsets get _padding => switch (widget.size) {
        SkolrSize.sm =>
          const EdgeInsets.symmetric(horizontal: SkolrSpacing.md, vertical: SkolrSpacing.xs),
        SkolrSize.md =>
          const EdgeInsets.symmetric(horizontal: SkolrSpacing.xl, vertical: SkolrSpacing.md),
        SkolrSize.lg =>
          const EdgeInsets.symmetric(horizontal: SkolrSpacing.xl, vertical: SkolrSpacing.lg),
      };

  TextStyle get _labelStyle => switch (widget.size) {
        SkolrSize.sm => SkolrTypography.labelMedium(),
        SkolrSize.md => SkolrTypography.labelLarge(),
        SkolrSize.lg => SkolrTypography.labelLarge(),
      };

  double get _iconSize => switch (widget.size) {
        SkolrSize.sm => 16,
        SkolrSize.md => 18,
        SkolrSize.lg => 20,
      };

  // ── Colors ──────────────────────────────────────────────────────────────

  _ButtonColors _resolveColors(ColorScheme cs) {
    if (widget._disabled) {
      return _ButtonColors(
        background: cs.onSurface.withValues(alpha: 0.12),
        foreground: cs.onSurface.withValues(alpha: 0.38),
        border: Colors.transparent,
      );
    }
    return switch (widget.variant) {
      SkolrButtonVariant.primary => _ButtonColors(
          background: cs.primary,
          foreground: cs.onPrimary,
          border: Colors.transparent,
        ),
      SkolrButtonVariant.secondary => _ButtonColors(
          background: Colors.transparent,
          foreground: cs.primary,
          border: cs.outline,
        ),
      SkolrButtonVariant.tertiary => _ButtonColors(
          background: Colors.transparent,
          foreground: cs.primary,
          border: Colors.transparent,
        ),
      SkolrButtonVariant.destructive => _ButtonColors(
          background: cs.error,
          foreground: cs.onError,
          border: Colors.transparent,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = _resolveColors(cs);
    final spinnerSize = _height * 0.4;

    final content = Stack(
      alignment: Alignment.center,
      children: [
        // Ghost label — keeps width stable during loading
        Opacity(
          opacity: widget.isLoading ? 0.0 : 1.0,
          child: Padding(
            padding: _padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.leadingIcon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      color: colors.foreground,
                      size: _iconSize,
                    ),
                    child: widget.leadingIcon!,
                  ),
                  const SizedBox(width: SkolrSpacing.sm),
                ],
                Text(
                  widget.label,
                  style: _labelStyle.copyWith(color: colors.foreground),
                ),
                if (widget.trailingIcon != null) ...[
                  const SizedBox(width: SkolrSpacing.sm),
                  IconTheme(
                    data: IconThemeData(
                      color: colors.foreground,
                      size: _iconSize,
                    ),
                    child: widget.trailingIcon!,
                  ),
                ],
              ],
            ),
          ),
        ),
        // Spinner — same position as label
        if (widget.isLoading)
          SizedBox(
            width: spinnerSize,
            height: spinnerSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(colors.foreground),
            ),
          ),
      ],
    );

    Widget button = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: SkolrMotion.fast,
          height: _height,
          constraints: BoxConstraints(minHeight: _height),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: SkolrRadius.md,
            border: colors.border != Colors.transparent
                ? Border.all(color: colors.border)
                : null,
          ),
          child: content,
        ),
      ),
    );

    if (widget.fullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}

class _ButtonColors {
  const _ButtonColors({
    required this.background,
    required this.foreground,
    required this.border,
  });
  final Color background;
  final Color foreground;
  final Color border;
}
