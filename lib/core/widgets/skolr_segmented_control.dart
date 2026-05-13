import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/design_system.dart';

/// A 2–4 segment control with an animated sliding thumb.
///
/// The thumb slides between segments using a [TweenAnimationBuilder] so
/// the animation continues from wherever the thumb currently is, even if
/// the user taps rapidly.
///
/// Usage:
/// ```dart
/// SkolrSegmentedControl(
///   segments: const ['Daily', 'Weekly', 'Monthly'],
///   selectedIndex: _period,
///   onChanged: (i) => setState(() => _period = i),
/// )
/// ```
class SkolrSegmentedControl extends StatelessWidget {
  const SkolrSegmentedControl({
    super.key,
    required this.segments,
    required this.selectedIndex,
    required this.onChanged,
  }) : assert(
          segments.length >= 2 && segments.length <= 4,
          'SkolrSegmentedControl requires 2–4 segments.',
        );

  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: SkolrRadius.md,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segmentWidth = constraints.maxWidth / segments.length;

          return Stack(
            children: [
              // Sliding thumb
              TweenAnimationBuilder<double>(
                tween: Tween(end: selectedIndex.toDouble()),
                duration: SkolrMotion.base,
                curve: SkolrMotion.emphasized,
                builder: (_, value, _) => Positioned(
                  left: value * segmentWidth,
                  top: 0,
                  bottom: 0,
                  width: segmentWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: SkolrRadius.sm,
                      boxShadow: SkolrShadows.soft,
                    ),
                  ),
                ),
              ),
              // Labels
              Row(
                children: segments.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final label = entry.value;
                  final isSelected = idx == selectedIndex;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (isSelected) return;
                        HapticFeedback.selectionClick();
                        onChanged(idx);
                      },
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: SkolrMotion.fast,
                          style: SkolrTypography.labelLarge(
                            color: isSelected
                                ? cs.onSurface
                                : cs.onSurfaceVariant,
                          ).copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                          child: Text(label),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
