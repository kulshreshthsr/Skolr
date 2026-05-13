import 'package:flutter/material.dart';

import '../design_system/design_system.dart';

/// A styled bottom sheet with drag handle, optional title row,
/// and scrollable content slot.
///
/// Use [SkolrBottomSheet.show] to present it modally.
///
/// Usage:
/// ```dart
/// SkolrBottomSheet.show(
///   context,
///   title: 'Filter Students',
///   child: Column(children: [...]),
/// );
/// ```
class SkolrBottomSheet extends StatelessWidget {
  const SkolrBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.showCloseButton = true,
  });

  final Widget child;
  final String? title;
  final bool showCloseButton;

  /// Presents a [SkolrBottomSheet] modally.
  ///
  /// Returns the value passed to [Navigator.pop] when dismissed.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showCloseButton = true,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      // Transparent so our custom container handles background + radius
      backgroundColor: Colors.transparent,
      barrierColor:
          Theme.of(context).colorScheme.scrim.withValues(alpha: 0.4),
      builder: (_) => SkolrBottomSheet(
        title: title,
        showCloseButton: showCloseButton,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mq = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: SkolrRadius.topXxl,
        border: Border(
          top: BorderSide(color: cs.outlineVariant, width: 1),
        ),
      ),
      // Respect keyboard — sheet rises above IME
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: SkolrSpacing.md),
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: SkolrRadius.full,
                ),
              ),
            ),
            // Title row
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  SkolrSpacing.lg,
                  SkolrSpacing.lg,
                  SkolrSpacing.sm,
                  0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title!,
                        style: SkolrTypography.titleLarge(color: cs.onSurface),
                      ),
                    ),
                    if (showCloseButton)
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        color: cs.onSurfaceVariant,
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Close',
                      ),
                  ],
                ),
              ),
            ] else if (showCloseButton) ...[
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: SkolrSpacing.sm,
                    top: SkolrSpacing.xs,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: cs.onSurfaceVariant,
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ),
              ),
            ],
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  SkolrSpacing.lg,
                  SkolrSpacing.lg,
                  SkolrSpacing.lg,
                  SkolrSpacing.xxl,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
