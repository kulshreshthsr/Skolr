import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'skolr_card.dart';

// ---------------------------------------------------------------------------
// DashboardCard — premium stat card for the home/dashboard grid.
//
// Two display modes:
//   • Default       — glass card, icon badge (tinted), metric, label
//   • hero: true    — gradient-fill card with white text (use for ONE
//                     standout stat per screen, e.g. "Welcome" hero)
//
// API kept backward-compatible with v1:
//   DashboardCard(title: 'Students', value: '1,248', icon: Icons.people)
//
// New optional props:
//   • iconTint      — override the icon badge color
//   • trend         — optional small trend chip ("+12%", "-3 today")
//   • trendUp       — colors the trend chip green (up) or red (down)
//   • onTap         — makes the card interactive (spring + ripple)
//   • hero          — gradient-fill variant
// ---------------------------------------------------------------------------

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconTint,
    this.trend,
    this.trendUp,
    this.onTap,
    this.hero = false,
  });

  final String title;
  final String value;
  final IconData icon;

  /// Override the default icon badge color (defaults to primary violet).
  final Color? iconTint;

  /// Optional trend label, e.g. "+12% this week".
  final String? trend;

  /// If true → success green; if false → danger red; if null → neutral grey.
  final bool? trendUp;

  /// Make the card tappable.
  final VoidCallback? onTap;

  /// Gradient-filled hero variant. Use sparingly (one per screen max).
  final bool hero;

  @override
  Widget build(BuildContext context) {
    if (hero) return _heroVariant(context);
    return _glassVariant(context);
  }

  // ── Glass variant (default) ──────────────────────────────────────────────
  Widget _glassVariant(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tint = iconTint ?? SkolrColors.primary;

    return SkolrCard(
      variant: onTap != null
          ? SkolrCardVariant.interactive
          : SkolrCardVariant.flat,
      onTap: onTap,
      padding: const EdgeInsets.all(SkolrSpacing.lg),
child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: [
    _IconBadge(icon: icon, tint: tint),
    const SkolrGap.md(), // ← was SkolrGap.lg() — slightly tighter
    Text(
      value,
      style: SkolrTypography.metricLarge(color: cs.onSurface),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    const SkolrGap.xs(),
    Text(
      title,
      style: SkolrTypography.bodyMedium(color: cs.onSurfaceVariant),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    // trend removed from grid cards so this never fires for them
    if (trend != null) ...[
      const SkolrGap.xs(), // ← was SkolrGap.sm()
      _TrendChip(text: trend!, up: trendUp),
    ],
  ],
),
    );
  }

  // ── Hero variant — gradient-filled standout card ─────────────────────────
  Widget _heroVariant(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(SkolrSpacing.xl),
      decoration: BoxDecoration(
        gradient: SkolrGradients.brand,
        borderRadius: SkolrRadius.xl,
        boxShadow: SkolrShadows.brandGlowSoft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: SkolrRadius.md,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SkolrGap.lg(),
          Text(
            value,
            style: SkolrTypography.metricLarge(color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SkolrGap.xs(),
          Text(
            title,
            style: SkolrTypography.bodyMedium(
              color: Colors.white.withValues(alpha: 0.85),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (trend != null) ...[
            const SkolrGap.sm(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SkolrSpacing.sm,
                vertical: SkolrSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: SkolrRadius.full,
              ),
              child: Text(
                trend!,
                style: SkolrTypography.labelMedium(color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return card;
    return GestureDetector(
      onTap: onTap,
      child: card,
    );
  }
}

// ─── Icon badge — rounded square with tinted fill ───────────────────────────

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.tint});
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tint.withValues(alpha: isDark ? 0.25 : 0.15),
            tint.withValues(alpha: isDark ? 0.12 : 0.06),
          ],
        ),
        borderRadius: SkolrRadius.md,
        border: Border.all(
          color: tint.withValues(alpha: isDark ? 0.35 : 0.2),
        ),
      ),
      child: Icon(icon, color: tint, size: 22),
    );
  }
}

// ─── Trend chip ─────────────────────────────────────────────────────────────

class _TrendChip extends StatelessWidget {
  const _TrendChip({required this.text, required this.up});
  final String text;
  final bool? up;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (fg, bg) = switch (up) {
      true => (SkolrColors.successStrong, SkolrColors.successSoft),
      false => (SkolrColors.dangerStrong, SkolrColors.dangerSoft),
      null => (cs.onSurfaceVariant, cs.surfaceContainerHigh),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SkolrSpacing.sm,
        vertical: SkolrSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: SkolrRadius.full,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (up != null)
            Icon(
              up! ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              size: 12,
              color: fg,
            ),
          if (up != null) const SizedBox(width: 4),
          Text(
            text,
            style: SkolrTypography.labelMedium(color: fg)
                .copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}