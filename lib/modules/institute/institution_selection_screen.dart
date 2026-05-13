import 'package:flutter/material.dart';

import '../../core/design_system/design_system.dart';
import '../../core/widgets/skolr_card.dart';
import 'institute_model.dart';
import 'screens/institute_setup_screen.dart';

// ---------------------------------------------------------------------------
// InstitutionSelectionScreen — premium onboarding step 1 of 2.
//
// Visual recipe:
//   • Radial gradient background
//   • Hero header with the brand logo mark + welcome copy
//   • Two large glass selection cards with staggered entry
//   • Each card has a tinted icon panel, title, subtitle, and chevron
//   • Spring-press on tap with haptic feedback
//   • "1 of 2" eyebrow so user knows where they are in the flow
// ---------------------------------------------------------------------------

class InstitutionSelectionScreen extends StatefulWidget {
  const InstitutionSelectionScreen({super.key});

  @override
  State<InstitutionSelectionScreen> createState() =>
      _InstitutionSelectionScreenState();
}

class _InstitutionSelectionScreenState extends State<InstitutionSelectionScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entryCtrl;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  void _select(InstituteType type) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (_, _, _) => InstituteSetupScreen(type: type),
        transitionsBuilder: (_, animation, _, child) {
          final tween = Tween<Offset>(
            begin: const Offset(0.05, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: SkolrMotion.emphasized));
          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: SkolrGradients.pageBackground(brightness),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(SkolrSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkolrGap.xxl(),
                // ── Step indicator ─────────────────────────────────
                _Entry(
                  controller: _entryCtrl,
                  start: 0.0,
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: SkolrGradients.brand,
                          borderRadius: SkolrRadius.sm,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SkolrGap.sm(),
                      Text(
                        'SETUP · STEP 1 OF 2',
                        style: SkolrTypography.labelSmall(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SkolrGap.xxl(),

                // ── Headline ───────────────────────────────────────
                _Entry(
                  controller: _entryCtrl,
                  start: 0.05,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'What kind of\n',
                          style: SkolrTypography.headlineLarge(
                            color: cs.onSurface,
                          ),
                        ),
                        TextSpan(
                          text: 'institution are you?',
                          style: SkolrTypography.headlineLarge(
                            color: SkolrColors.primary,
                          ).copyWith(
                            foreground: Paint()
                              ..shader = SkolrGradients.brand.createShader(
                                const Rect.fromLTWH(0, 0, 360, 40),
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SkolrGap.md(),

                _Entry(
                  controller: _entryCtrl,
                  start: 0.1,
                  child: Text(
                    'Skolr adapts its workflow, terminology, and permissions '
                    'to fit your institution.',
                    style: SkolrTypography.bodyLarge(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
                const SkolrGap.xxl(),
                const SkolrGap.lg(),

                // ── Selection cards ────────────────────────────────
                _Entry(
                  controller: _entryCtrl,
                  start: 0.2,
                  child: _SelectionCard(
                    title: 'Coaching Institute',
                    subtitle:
                        'Batches, fees, attendance, notes, WhatsApp reminders',
                    icon: Icons.menu_book_rounded,
                    tint: SkolrColors.primary,
                    onTap: () => _select(InstituteType.coaching),
                  ),
                ),
                const SkolrGap.lg(),
                _Entry(
                  controller: _entryCtrl,
                  start: 0.3,
                  child: _SelectionCard(
                    title: 'School',
                    subtitle:
                        'Classes, sections, staff, parent communication, reports',
                    icon: Icons.apartment_rounded,
                    tint: SkolrColors.secondary,
                    onTap: () => _select(InstituteType.school),
                  ),
                ),

                const Spacer(),

                // ── Footer hint ────────────────────────────────────
                _Entry(
                  controller: _entryCtrl,
                  start: 0.5,
                  child: Center(
                    child: Text(
                      'You can change this later in Settings',
                      style: SkolrTypography.bodySmall(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SkolrGap.md(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Premium selection card ─────────────────────────────────────────────────

class _SelectionCard extends StatelessWidget {
  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color tint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SkolrCard(
      variant: SkolrCardVariant.interactive,
      onTap: onTap,
      padding: const EdgeInsets.all(SkolrSpacing.xl),
      child: Row(
        children: [
          // Icon panel
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  tint.withValues(alpha: isDark ? 0.3 : 0.18),
                  tint.withValues(alpha: isDark ? 0.12 : 0.06),
                ],
              ),
              borderRadius: SkolrRadius.lg,
              border: Border.all(
                color: tint.withValues(alpha: isDark ? 0.4 : 0.22),
              ),
            ),
            child: Icon(icon, color: tint, size: 32),
          ),
          const SkolrGap.lg(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: SkolrTypography.titleLarge(color: cs.onSurface),
                ),
                const SkolrGap.xs(),
                Text(
                  subtitle,
                  style: SkolrTypography.bodyMedium(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SkolrGap.sm(),
          Icon(
            Icons.arrow_forward_rounded,
            color: cs.onSurfaceVariant,
            size: 22,
          ),
        ],
      ),
    );
  }
}

// ─── Staggered fade+rise entry wrapper ──────────────────────────────────────

class _Entry extends StatelessWidget {
  const _Entry({
    required this.controller,
    required this.start,
    required this.child,
  });

  final AnimationController controller;
  final double start;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final end = (start + 0.5).clamp(0.0, 1.0);
    final curved = CurvedAnimation(
      parent: controller,
      curve: Interval(start, end, curve: SkolrMotion.expressive),
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (context, child) {
        return Opacity(
          opacity: curved.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - curved.value) * 24),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}