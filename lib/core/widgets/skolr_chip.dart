import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/design_system.dart';

/// Chip size.
enum SkolrChipSize { sm, md }

/// A compact label chip with optional selection state and leading icon.
///
/// When [onTap] is null the chip is display-only (non-interactive).
/// When [onTap] is provided the chip is selectable and shows a checkmark
/// when [selected] is true.
///
/// Usage:
/// ```dart
/// // Filter chip (selectable)
/// SkolrChip(
///   label: 'Present',
///   selected: _showPresent,
///   onTap: () => setState(() => _showPresent = !_showPresent),
///   leading: Icon(Icons.check_circle_outline_rounded),
/// )
///
/// // Status chip (display only)
/// SkolrChip(label: 'Paid', selected: true)
/// ```
class SkolrChip extends StatelessWidget {
  const SkolrChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.leading,
    this.size = SkolrChipSize.md,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Widget? leading;
  final SkolrChipSize size;

  bool get _interactive => onTap != null;

  double get _height => size == SkolrChipSize.sm ? 28 : 36;

  EdgeInsets get _padding => size == SkolrChipSize.sm
      ? const EdgeInsets.symmetric(
          horizontal: SkolrSpacing.md, vertical: SkolrSpacing.xs)
      : const EdgeInsets.symmetric(
          horizontal: SkolrSpacing.lg, vertical: SkolrSpacing.sm);

  TextStyle _labelStyle(Color color) => size == SkolrChipSize.sm
      ? SkolrTypography.labelMedium(color: color)
      : SkolrTypography.labelLarge(color: color);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final bgColor = selected
        ? cs.primaryContainer
        : cs.surfaceContainerHigh;

    final fgColor = selected
        ? cs.onPrimaryContainer
        : cs.onSurfaceVariant;

    final borderColor = selected ? Colors.transparent : cs.outlineVariant;

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated checkmark for selectable chips
        if (_interactive)
          AnimatedSize(
            duration: SkolrMotion.fast,
            curve: SkolrMotion.decelerate,
            child: selected
                ? Padding(
                    padding: const EdgeInsets.only(right: SkolrSpacing.xs),
                    child: Icon(
                      Icons.check_rounded,
                      size: size == SkolrChipSize.sm ? 14 : 16,
                      color: fgColor,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        // Custom leading icon
        if (leading != null && !selected) ...[
          IconTheme(
            data: IconThemeData(
              color: fgColor,
              size: size == SkolrChipSize.sm ? 14 : 16,
            ),
            child: leading!,
          ),
          const SizedBox(width: SkolrSpacing.xs),
        ],
        Text(label, style: _labelStyle(fgColor)),
      ],
    );

    Widget chip = AnimatedContainer(
      duration: SkolrMotion.fast,
      height: _height,
      padding: _padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: SkolrRadius.full,
        border: Border.all(color: borderColor),
      ),
      child: content,
    );

    if (_interactive) {
      chip = GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap!();
        },
        child: chip,
      );
    }

    return chip;
  }
}
