import 'package:flutter/material.dart';

import '../design_system/design_system.dart';

/// Badge semantic variant — controls the color palette.
enum SkolrBadgeVariant { neutral, success, warning, danger, info }

/// Badge size.
enum SkolrBadgeSize {
  /// A 8×8 dot. No label. Use as a notification indicator.
  dot,

  /// Pill with label text. Minimum width ensures round ends on 1-char values.
  sm,
}

/// Pill-shaped status label or notification indicator.
///
/// Usage:
/// ```dart
/// // Inline status label
/// SkolrBadge(label: 'Paid', variant: SkolrBadgeVariant.success)
/// SkolrBadge(label: 'Overdue', variant: SkolrBadgeVariant.danger)
///
/// // Notification dot (no label)
/// SkolrBadge(size: SkolrBadgeSize.dot, variant: SkolrBadgeVariant.danger)
/// ```
class SkolrBadge extends StatelessWidget {
  const SkolrBadge({
    super.key,
    this.label,
    this.variant = SkolrBadgeVariant.neutral,
    this.size = SkolrBadgeSize.sm,
  }) : assert(
          size != SkolrBadgeSize.dot || label == null,
          'SkolrBadge.dot should not have a label.',
        );

  final String? label;
  final SkolrBadgeVariant variant;
  final SkolrBadgeSize size;

  (Color, Color) _colors(ColorScheme cs) => switch (variant) {
        SkolrBadgeVariant.neutral => (
            cs.surfaceContainerHigh,
            cs.onSurfaceVariant,
          ),
        SkolrBadgeVariant.success => (
            SkolrColors.successContainer,
            SkolrColors.onSuccessContainer,
          ),
        SkolrBadgeVariant.warning => (
            SkolrColors.warningContainer,
            SkolrColors.onWarningContainer,
          ),
        SkolrBadgeVariant.danger => (
            SkolrColors.dangerContainer,
            SkolrColors.onDangerContainer,
          ),
        SkolrBadgeVariant.info => (
            SkolrColors.infoDark,
            SkolrColors.onInfoDark,
          ),
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (bg, fg) = _colors(cs);

    if (size == SkolrBadgeSize.dot) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SkolrSpacing.md,
        vertical: 3,
      ),
      constraints: const BoxConstraints(minWidth: 24),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: SkolrRadius.full,
      ),
      child: Text(
        label ?? '',
        style: SkolrTypography.labelMedium(color: fg),
        textAlign: TextAlign.center,
      ),
    );
  }
}
