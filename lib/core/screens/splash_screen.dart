import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../design_system/design_system.dart';
import '../../modules/dashboard/screens/dashboard_screen.dart';
import '../../modules/institute/institute_provider.dart';
import '../../modules/institute/institution_selection_screen.dart';

// ---------------------------------------------------------------------------
// SplashScreen — premium "brand reveal" entry moment.
//
// Animation timeline (total ~1800ms before handoff):
//   0–600ms   → page background fades in
//   200–900ms → logo mark scales in with expressive (back-out) curve
//                + violet glow blooms behind it
//   600–1200ms → wordmark "Skolr" slides up with gradient text fill
//   900–1400ms → tagline fades in
//   1400ms+   → handoff to next screen (driven by institute provider)
//
// The wait isn't artificial — we use this time to read shared_preferences
// via the institute provider. The animation simply masks the load.
// ---------------------------------------------------------------------------

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  bool _hasNavigated = false;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(instituteProvider.notifier).initialize();
    });

    // Mark as ready after minimum splash duration so we don't flash past
    _entryCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) setState(() => _isReady = true);
        _maybeNavigate();
      }
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  void _maybeNavigate() {
    if (_hasNavigated) return;
    if (!_isReady) return;
    final state = ref.read(instituteProvider);
    if (state.isLoading) return;

    _hasNavigated = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, _, _) => state.institute != null
            ? const DashboardScreen()
            : const InstitutionSelectionScreen(),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for the provider to settle, then navigate if animation is done
    ref.listen<InstituteState>(instituteProvider, (_, next) {
      if (!next.isLoading) _maybeNavigate();
    });

    final brightness = Theme.of(context).brightness;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: brightness == Brightness.dark
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
            ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: SkolrGradients.pageBackground(brightness),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),
                // ── Logo reveal ─────────────────────────────────
                _LogoReveal(controller: _entryCtrl),
                const SkolrGap.xxl(),
                // ── Wordmark with gradient text fill ───────────
                _Wordmark(controller: _entryCtrl),
                const SkolrGap.md(),
                // ── Tagline ────────────────────────────────────
                _Tagline(controller: _entryCtrl),
                const Spacer(flex: 4),
                // ── Progress hint ──────────────────────────────
                _ProgressHint(controller: _entryCtrl),
                const SkolrGap.xxl(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Logo reveal: scale-in with violet glow bloom ───────────────────────────

class _LogoReveal extends StatelessWidget {
  const _LogoReveal({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    // Logo scales/fades during 0.1 → 0.55 of the timeline
    final logoCurve = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.1, 0.55, curve: SkolrMotion.expressive),
    );

    // Glow blooms during 0.15 → 0.7
    final glowCurve = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.15, 0.7, curve: SkolrMotion.decelerate),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring (animated bloom)
              Opacity(
                opacity: 0.4 * glowCurve.value,
                child: Container(
                  width: 200 * (0.6 + 0.4 * glowCurve.value),
                  height: 200 * (0.6 + 0.4 * glowCurve.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        SkolrColors.primary.withValues(alpha: 0.6),
                        SkolrColors.secondary.withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // Logo mark
              Transform.scale(
                scale: logoCurve.value,
                child: Opacity(
                  opacity: logoCurve.value.clamp(0.0, 1.0),
                  child: Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: SkolrShadows.brandGlowStrong, // keep the glow
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        'assets/images/splash.png',
                        width: 112,
                        height: 112,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Wordmark: "Skolr" with gradient text fill ──────────────────────────────

class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.4, 0.75, curve: SkolrMotion.expressive),
    );

    return AnimatedBuilder(
      animation: curve,
      builder: (context, _) {
        return Opacity(
          opacity: curve.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - curve.value) * 16),
            child: ShaderMask(
              shaderCallback: (rect) => SkolrGradients.brand.createShader(rect),
              child: Text(
                'Skolr',
                style: SkolrTypography.displayMedium(color: Colors.white)
                    .copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Tagline ────────────────────────────────────────────────────────────────

class _Tagline extends StatelessWidget {
  const _Tagline({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final curve = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.55, 0.9, curve: SkolrMotion.decelerate),
    );

    return AnimatedBuilder(
      animation: curve,
      builder: (context, _) {
        return Opacity(
          opacity: curve.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - curve.value) * 8),
            child: Text(
              'Education infrastructure, reimagined.',
              style: SkolrTypography.bodyLarge(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

// ─── Subtle "loading" hint at the bottom ────────────────────────────────────

class _ProgressHint extends StatelessWidget {
  const _ProgressHint({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final curve = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.7, 1.0, curve: SkolrMotion.decelerate),
    );

    return AnimatedBuilder(
      animation: curve,
      builder: (context, _) {
        return Opacity(
          opacity: curve.value.clamp(0.0, 1.0) * 0.7,
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                cs.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
        );
      },
    );
  }
}