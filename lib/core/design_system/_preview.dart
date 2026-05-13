import 'package:flutter/material.dart';

import 'design_system.dart';

// ---------------------------------------------------------------------------
// Design System Preview — v2.1
//
// Visual audit page for every design token. Not shipped in production.
// Route to this from a debug menu, or temporarily set as home in main.dart
// to inspect the system.
//
// Includes a theme toggle (top-right) so you can verify dark AND light
// modes render correctly without restarting the app.
// ---------------------------------------------------------------------------

class DesignSystemPreview extends StatelessWidget {
  const DesignSystemPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: SkolrThemeController.instance,
      builder: (context, _) {
        final brightness = Theme.of(context).brightness;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Design System v2'),
            actions: [
              IconButton(
                icon: Icon(
                  brightness == Brightness.dark
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                ),
                tooltip: 'Toggle theme',
                onPressed: SkolrThemeController.instance.toggle,
              ),
              const SkolrGap.sm(),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: SkolrGradients.pageBackground(brightness),
            ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                SkolrSpacing.lg,
                SkolrSpacing.xxxl + SkolrSpacing.xl,
                SkolrSpacing.lg,
                SkolrSpacing.xxxl,
              ),
              children: const [
                _SectionHeader('Brand', subtitle: 'Logo-derived hues'),
                _BrandColors(),
                SkolrGap.xxl(),
                _SectionHeader('Signature Gradient',
                    subtitle: 'Violet → Electric blue, 135°'),
                _GradientStrip(),
                SkolrGap.xxl(),
                _SectionHeader('Midnight Surface Stack',
                    subtitle: 'Dark mode foundation'),
                _MidnightStack(),
                SkolrGap.xxl(),
                _SectionHeader('Status Colors',
                    subtitle: 'Soft / strong variants'),
                _StatusColors(),
                SkolrGap.xxl(),
                _SectionHeader('Avatar Pairs',
                    subtitle: 'Deterministic by seed'),
                _AvatarPairs(),
                SkolrGap.xxxl(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Section header ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label, {this.subtitle});
  final String label;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: SkolrSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: SkolrTypography.labelSmall(color: SkolrColors.primary),
          ),
          const SkolrGap.xs(),
          Text(label, style: SkolrTypography.titleLarge(color: cs.onSurface)),
          if (subtitle != null) ...[
            const SkolrGap.xs(),
            Text(
              subtitle!,
              style: SkolrTypography.bodyMedium(color: cs.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Color swatch primitive ─────────────────────────────────────────────────
// FIX: `height` is now a constructor parameter with a default, so the field
// is always initialized.

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.onColor,
    required this.label,
    this.subLabel,
    this.height = 88,
  });

  final Color color;
  final Color onColor;
  final String label;
  final String? subLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: SkolrRadius.lg,
      ),
      padding: const EdgeInsets.all(SkolrSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(label, style: SkolrTypography.labelMedium(color: onColor)),
          if (subLabel != null)
            Text(
              subLabel!,
              style: SkolrTypography.bodySmall(
                color: onColor.withValues(alpha: 0.75),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Brand colors ───────────────────────────────────────────────────────────

class _BrandColors extends StatelessWidget {
  const _BrandColors();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(
            child: _Swatch(
              color: SkolrColors.primary,
              onColor: Colors.white,
              label: 'primary',
              subLabel: '#8B5CF6',
            ),
          ),
          const SkolrGap.md(),
          Expanded(
            child: _Swatch(
              color: SkolrColors.secondary,
              onColor: Colors.white,
              label: 'secondary',
              subLabel: '#3B82F6',
            ),
          ),
        ]),
        const SkolrGap.md(),
        Row(children: [
          Expanded(
            child: _Swatch(
              color: SkolrColors.accent,
              onColor: Colors.white,
              label: 'accent',
              subLabel: '#D946EF',
            ),
          ),
          const SkolrGap.md(),
          Expanded(
            child: _Swatch(
              color: SkolrColors.primaryHover,
              onColor: Colors.white,
              label: 'primaryHover',
              subLabel: '#9D6FFF',
            ),
          ),
        ]),
      ],
    );
  }
}

class _GradientStrip extends StatelessWidget {
  const _GradientStrip();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: SkolrGradients.brand,
        borderRadius: SkolrRadius.lg,
        boxShadow: SkolrShadows.brandGlowSoft,
      ),
      alignment: Alignment.center,
      child: Text(
        'SkolrGradients.brand',
        style: SkolrTypography.labelLarge(color: Colors.white),
      ),
    );
  }
}

class _MidnightStack extends StatelessWidget {
  const _MidnightStack();

  @override
  Widget build(BuildContext context) {
    final tones = [
      (SkolrColors.midnight900, 'midnight900'),
      (SkolrColors.midnight800, 'midnight800'),
      (SkolrColors.midnight700, 'midnight700'),
      (SkolrColors.midnight600, 'midnight600'),
      (SkolrColors.midnight500, 'midnight500'),
      (SkolrColors.midnight400, 'midnight400'),
    ];
    return Column(
      children: tones
          .map((t) => Padding(
                padding: const EdgeInsets.only(bottom: SkolrSpacing.sm),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: t.$1,
                    borderRadius: SkolrRadius.md,
                    border: Border.all(color: SkolrColors.glassBorder),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: SkolrSpacing.md,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    t.$2,
                    style: SkolrTypography.labelMedium(color: Colors.white),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _StatusColors extends StatelessWidget {
  const _StatusColors();
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: _Swatch(
          color: SkolrColors.success,
          onColor: Colors.black,
          label: 'success',
        ),
      ),
      const SkolrGap.md(),
      Expanded(
        child: _Swatch(
          color: SkolrColors.warning,
          onColor: Colors.black,
          label: 'warning',
        ),
      ),
      const SkolrGap.md(),
      Expanded(
        child: _Swatch(
          color: SkolrColors.danger,
          onColor: Colors.white,
          label: 'danger',
        ),
      ),
    ]);
  }
}

class _AvatarPairs extends StatelessWidget {
  const _AvatarPairs();
  @override
  Widget build(BuildContext context) {
    final samples = ['Rahul', 'Priya', 'Aman', 'Neha', 'Vikas', 'Anika'];
    return Wrap(
      spacing: SkolrSpacing.md,
      runSpacing: SkolrSpacing.md,
      children: samples.map((name) {
        final (bg, fg) = SkolrColors.avatarFor(name);
        return Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: SkolrRadius.full,
              ),
              alignment: Alignment.center,
              child: Text(
                name[0],
                style: SkolrTypography.titleLarge(color: fg),
              ),
            ),
            const SkolrGap.xs(),
            Text(
              name,
              style: SkolrTypography.labelMedium(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}