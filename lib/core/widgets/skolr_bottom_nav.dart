import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/design_system.dart';

/// A single navigation destination.
class SkolrNavItem {
  const SkolrNavItem({
    required this.icon,
    required this.label,
    IconData? activeIcon,
  }) : activeIcon = activeIcon ?? icon;

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// Bottom navigation bar with an animated pill indicator and optional
/// frosted-glass background when content scrolls beneath it.
///
/// Designed for 2–4 items. Use with [Scaffold.extendBody] = true and
/// pass the same [ScrollController] used by the body scroll view so the
/// glass activates automatically.
///
/// Usage:
/// ```dart
/// Scaffold(
///   extendBody: true,
///   body: ListView(..., controller: _scrollCtrl),
///   bottomNavigationBar: SkolrBottomNav(
///     currentIndex: _tab,
///     scrollController: _scrollCtrl,
///     onTap: (i) => setState(() => _tab = i),
///     items: const [
///       SkolrNavItem(icon: Icons.home_rounded, label: 'Home'),
///       SkolrNavItem(icon: Icons.people_rounded, label: 'Students'),
///     ],
///   ),
/// )
/// ```
class SkolrBottomNav extends StatefulWidget {
  const SkolrBottomNav({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
    this.scrollController,
  }) : assert(items.length >= 2 && items.length <= 4,
            'SkolrBottomNav requires 2–4 items.');

  final int currentIndex;
  final List<SkolrNavItem> items;
  final ValueChanged<int> onTap;
  final ScrollController? scrollController;

  @override
  State<SkolrBottomNav> createState() => _SkolrBottomNavState();
}

class _SkolrBottomNavState extends State<SkolrBottomNav> {
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(SkolrBottomNav old) {
    super.didUpdateWidget(old);
    if (old.scrollController != widget.scrollController) {
      old.scrollController?.removeListener(_onScroll);
      widget.scrollController?.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final scrolled = (widget.scrollController?.offset ?? 0) > 4;
    if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mq = MediaQuery.of(context);

    // Height: icon + label + safe area
    const barHeight = 64.0;
    final totalHeight = barHeight + mq.padding.bottom;

    Widget navContent = LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final itemWidth = totalWidth / widget.items.length;

        return SizedBox(
          height: barHeight,
          child: Stack(
            children: [
              // Animated pill behind the active item
              TweenAnimationBuilder<double>(
                tween: Tween(end: widget.currentIndex.toDouble()),
                duration: SkolrMotion.base,
                curve: SkolrMotion.emphasized,
                builder: (_, value, _) {
                  return Positioned(
                    top: (barHeight - 32) / 2,
                    left: value * itemWidth + (itemWidth - 64) / 2,
                    child: Container(
                      width: 64,
                      height: 32,
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: SkolrRadius.full,
                      ),
                    ),
                  );
                },
              ),
              // Tab items
              Row(
                children: widget.items.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  final isActive = idx == widget.currentIndex;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        widget.onTap(idx);
                      },
                      child: SizedBox(
                        height: barHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: SkolrMotion.fast,
                              child: Icon(
                                isActive ? item.activeIcon : item.icon,
                                key: ValueKey(isActive),
                                size: 22,
                                color: isActive
                                    ? cs.onPrimaryContainer
                                    : cs.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.label,
                              style: SkolrTypography.labelMedium(
                                color: isActive
                                    ? cs.onSurface
                                    : cs.onSurfaceVariant,
                              ).copyWith(
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );

    // Frosted glass container — activated when content scrolls under
    Widget bar = AnimatedContainer(
      duration: SkolrMotion.base,
      height: totalHeight,
      decoration: BoxDecoration(
        // On dark mode, rely on a stronger border instead of tint
        border: Border(
          top: BorderSide(
            color: cs.outlineVariant.withValues(
              alpha: _isScrolled ? 1.0 : 0.0,
            ),
            width: 1,
          ),
        ),
        color: _isScrolled
            ? cs.surface.withValues(alpha: 0.85)
            : cs.surface,
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: mq.padding.bottom),
        child: navContent,
      ),
    );

    // Wrap with BackdropFilter only when scrolled (avoids unnecessary GPU cost)
    if (_isScrolled) {
      bar = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: bar,
        ),
      );
    }

    return bar;
  }
}
