import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/skolr_card.dart';
import '../../../core/widgets/skolr_text_field.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../institute_model.dart';
import '../institute_provider.dart';

// ---------------------------------------------------------------------------
// InstituteSetupScreen — premium onboarding step 2 of 2.
//
// Visual recipe:
//   • Radial gradient background continues from selection screen
//   • Back button + step indicator at top
//   • Type "pill" showing what was selected (visual continuity)
//   • Headline + subhead
//   • Glass card containing the form
//   • Gradient submit CTA with violet glow
// ---------------------------------------------------------------------------

class InstituteSetupScreen extends ConsumerStatefulWidget {
  final InstituteType type;

  const InstituteSetupScreen({super.key, required this.type});

  @override
  ConsumerState<InstituteSetupScreen> createState() =>
      _InstituteSetupScreenState();
}

class _InstituteSetupScreenState extends ConsumerState<InstituteSetupScreen>
    with TickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  late final AnimationController _entryCtrl;

  String? _nameError;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _nameError = 'Institute name is required');
      return;
    }
    setState(() {
      _nameError = null;
      _isSaving = true;
    });

    await ref.read(instituteProvider.notifier).save(
          InstituteModel(
            instituteName: _nameCtrl.text.trim(),
            instituteType: widget.type,
            phone: _phoneCtrl.text.trim(),
            address: _addressCtrl.text.trim(),
          ),
        );

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, _, _) => const DashboardScreen(),
          transitionsBuilder: (_, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final cs = Theme.of(context).colorScheme;
    final typeLabel = widget.type.label;
    final typeIcon = widget.type == InstituteType.coaching
        ? Icons.menu_book_rounded
        : Icons.apartment_rounded;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: SkolrGradients.pageBackground(brightness),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(SkolrSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top bar: back + step ────────────────────────
                _Entry(
                  controller: _entryCtrl,
                  start: 0.0,
                  child: Row(
                    children: [
                      _BackButton(onTap: () => Navigator.pop(context)),
                      const SkolrGap.md(),
                      Text(
                        'SETUP · STEP 2 OF 2',
                        style: SkolrTypography.labelSmall(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SkolrGap.xxl(),

                // ── Type pill (visual continuity from prev screen) ─
                _Entry(
                  controller: _entryCtrl,
                  start: 0.05,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SkolrSpacing.md,
                      vertical: SkolrSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          SkolrColors.primary
                              .withValues(alpha: brightness == Brightness.dark ? 0.2 : 0.1),
                          SkolrColors.secondary
                              .withValues(alpha: brightness == Brightness.dark ? 0.12 : 0.06),
                        ],
                      ),
                      borderRadius: SkolrRadius.full,
                      border: Border.all(
                        color: SkolrColors.primary.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(typeIcon, color: SkolrColors.primary, size: 16),
                        const SkolrGap.xs(),
                        Text(
                          typeLabel,
                          style: SkolrTypography.labelMedium(
                            color: SkolrColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SkolrGap.lg(),

                // ── Headline ────────────────────────────────────
                _Entry(
                  controller: _entryCtrl,
                  start: 0.1,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Tell us about\n',
                          style: SkolrTypography.headlineLarge(
                            color: cs.onSurface,
                          ),
                        ),
                        TextSpan(
                          text: 'your institute',
                          style: SkolrTypography.headlineLarge(
                            color: SkolrColors.primary,
                          ).copyWith(
                            foreground: Paint()
                              ..shader = SkolrGradients.brand.createShader(
                                const Rect.fromLTWH(0, 0, 320, 40),
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SkolrGap.sm(),

                _Entry(
                  controller: _entryCtrl,
                  start: 0.15,
                  child: Text(
                    'Just the basics for now — you can refine details anytime.',
                    style: SkolrTypography.bodyLarge(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
                const SkolrGap.xxl(),

                // ── Glass form card ─────────────────────────────
                _Entry(
                  controller: _entryCtrl,
                  start: 0.2,
                  child: SkolrCard(
                    padding: const EdgeInsets.all(SkolrSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FieldLabel('Institute Name', required: true),
                        const SkolrGap.sm(),
                        SkolrTextField(
                          controller: _nameCtrl,
                          hint: 'e.g. Bright Future Coaching',
                          error: _nameError,
                          prefixIcon:
                              const Icon(Icons.school_outlined),
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) {
                            if (_nameError != null) {
                              setState(() => _nameError = null);
                            }
                          },
                        ),
                        const SkolrGap.lg(),
                        _FieldLabel('Phone Number'),
                        const SkolrGap.sm(),
                        SkolrTextField(
                          controller: _phoneCtrl,
                          hint: '+91 9876543210',
                          keyboardType: TextInputType.phone,
                          prefixIcon: const Icon(Icons.phone_outlined),
                          textInputAction: TextInputAction.next,
                        ),
                        const SkolrGap.lg(),
                        _FieldLabel('Address'),
                        const SkolrGap.sm(),
                        SkolrTextField(
                          controller: _addressCtrl,
                          hint: '123 Main Street, Kanpur',
                          maxLines: 3,
                          prefixIcon: const Icon(Icons.place_outlined),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _save(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SkolrGap.xxl(),

                // ── Submit CTA ──────────────────────────────────
                _Entry(
                  controller: _entryCtrl,
                  start: 0.3,
                  child: PrimaryButton(
                    text: 'Get Started',
                    trailingIcon: Icons.arrow_forward_rounded,
                    loading: _isSaving,
                    onPressed: _save,
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {this.required = false});
  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          text,
          style: SkolrTypography.labelLarge(color: cs.onSurface),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: SkolrTypography.labelLarge(color: SkolrColors.danger),
          ),
        ],
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: SkolrRadius.md,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark
                ? SkolrColors.midnight600.withValues(alpha: 0.6)
                : SkolrColors.lightSurfaceAlt,
            borderRadius: SkolrRadius.md,
            border: Border.all(
              color: isDark
                  ? SkolrColors.glassBorder
                  : SkolrColors.lightBorder,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_back_rounded,
            size: 20,
            color: cs.onSurface,
          ),
        ),
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
            offset: Offset(0, (1 - curved.value) * 20),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}