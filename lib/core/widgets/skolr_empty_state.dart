import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'skolr_button.dart';

/// Centered empty-state layout with illustration slot, headline,
/// supporting text, and up to two CTAs.
///
/// Design principle #10: Empty is not blank.
/// Every empty state must explain WHY it's empty and what to do next.
///
/// Usage:
/// ```dart
/// SkolrEmptyState(
///   illustration: Icon(Icons.people_outline_rounded,
///       size: 72, color: cs.onSurfaceVariant),
///   headline: 'No students yet',
///   supportText: 'Add your first student to start tracking attendance.',
///   primaryAction: 'Add Student',
///   onPrimaryAction: () => Navigator.push(...),
/// )
/// ```
class SkolrEmptyState extends StatelessWidget {
  const SkolrEmptyState({
    super.key,
    this.illustration,
    required this.headline,
    this.supportText,
    this.primaryAction,
    this.onPrimaryAction,
    this.secondaryAction,
    this.onSecondaryAction,
  });

  /// Any widget — icon, image, Lottie, SVG. Constrained to 120×120.
  final Widget? illustration;

  final String headline;

  /// One sentence max. Explains context, not just restates headline.
  final String? supportText;

  final String? primaryAction;
  final VoidCallback? onPrimaryAction;
  final String? secondaryAction;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SkolrSpacing.xxxl,
          vertical: SkolrSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (illustration != null) ...[
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 120,
                  maxHeight: 120,
                ),
                child: illustration,
              ),
              const SkolrGap.xl(),
            ],
            Text(
              headline,
              style: SkolrTypography.headlineMedium(color: cs.onSurface),
              textAlign: TextAlign.center,
            ),
            if (supportText != null) ...[
              const SkolrGap.sm(),
              Text(
                supportText!,
                style: SkolrTypography.bodyMedium(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
            if (primaryAction != null) ...[
              const SkolrGap.xl(),
              SkolrButton(
                label: primaryAction!,
                onPressed: onPrimaryAction,
                fullWidth: false,
              ),
            ],
            if (secondaryAction != null) ...[
              const SkolrGap.sm(),
              SkolrButton(
                label: secondaryAction!,
                onPressed: onSecondaryAction,
                variant: SkolrButtonVariant.tertiary,
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
