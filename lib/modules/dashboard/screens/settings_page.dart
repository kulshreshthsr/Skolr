import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/skolr_card.dart';
import '../../../core/widgets/skolr_text_field.dart';
import '../../institute/institute_model.dart';
import '../../institute/institute_provider.dart';
import '../../institute/institution_selection_screen.dart';

// ---------------------------------------------------------------------------
// SettingsPage — institute details + app preferences + danger zone.
//
// Visual recipe:
//   • Page gradient background
//   • "Settings" headline + subhead
//   • Glass card: institute details form
//   • Glass card: appearance (theme toggle row)
//   • Glass card: danger zone (reset app) with red accent border
// ---------------------------------------------------------------------------

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late InstituteType _selectedType;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final institute = ref.read(instituteProvider).institute;
    _nameCtrl = TextEditingController(text: institute?.instituteName ?? '');
    _phoneCtrl = TextEditingController(text: institute?.phone ?? '');
    _addressCtrl = TextEditingController(text: institute?.address ?? '');
    _selectedType = institute?.instituteType ?? InstituteType.coaching;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Institute name cannot be empty.'),
          backgroundColor: SkolrColors.danger,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final existing = ref.read(instituteProvider).institute;
    await ref.read(instituteProvider.notifier).save(
          (existing ??
                  const InstituteModel(
                    instituteName: '',
                    instituteType: InstituteType.coaching,
                    phone: '',
                    address: '',
                  ))
              .copyWith(
            instituteName: name,
            instituteType: _selectedType,
            phone: _phoneCtrl.text.trim(),
            address: _addressCtrl.text.trim(),
          ),
        );

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Settings saved'),
          backgroundColor: SkolrColors.success,
        ),
      );
    }
  }

  Future<void> _resetApp() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset App'),
        content: const Text(
          'This will remove your institute setup and return to the '
          'onboarding screen. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Reset',
              style: TextStyle(color: SkolrColors.danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(instituteProvider.notifier).clear();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const InstitutionSelectionScreen(),
        ),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: SkolrGradients.pageBackground(brightness),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              SkolrSpacing.xl,
              SkolrSpacing.xl,
              SkolrSpacing.xl,
              SkolrSpacing.xxxxl + SkolrSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────────────
                Text(
                  'Settings',
                  style: SkolrTypography.headlineLarge(color: cs.onSurface),
                ),
                const SkolrGap.xs(),
                Text(
                  'Manage your institute details and app preferences',
                  style: SkolrTypography.bodyLarge(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SkolrGap.xxl(),

                // ── Section: Institute Details ────────────────
                _SectionLabel(icon: Icons.school_rounded, label: 'INSTITUTE'),
                const SkolrGap.md(),
                SkolrCard(
                  padding: const EdgeInsets.all(SkolrSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel('Institute Name'),
                      const SkolrGap.sm(),
                      SkolrTextField(
                        controller: _nameCtrl,
                        hint: 'e.g. Bright Future Coaching',
                        prefixIcon: const Icon(Icons.school_outlined),
                      ),
                      const SkolrGap.lg(),
                      _FieldLabel('Institute Type'),
                      const SkolrGap.sm(),
                      _TypePicker(
                        selected: _selectedType,
                        onChanged: (t) => setState(() => _selectedType = t),
                      ),
                      const SkolrGap.lg(),
                      _FieldLabel('Phone Number'),
                      const SkolrGap.sm(),
                      SkolrTextField(
                        controller: _phoneCtrl,
                        hint: '+91 9876543210',
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                      const SkolrGap.lg(),
                      _FieldLabel('Address'),
                      const SkolrGap.sm(),
                      SkolrTextField(
                        controller: _addressCtrl,
                        hint: '123 Main Street, Kanpur',
                        maxLines: 3,
                        prefixIcon: const Icon(Icons.place_outlined),
                      ),
                      const SkolrGap.xl(),
                      PrimaryButton(
                        text: 'Save Changes',
                        loading: _isSaving,
                        onPressed: _save,
                      ),
                    ],
                  ),
                ),
                const SkolrGap.xxl(),

                // ── Section: Appearance ───────────────────────
                _SectionLabel(
                    icon: Icons.palette_outlined, label: 'APPEARANCE'),
                const SkolrGap.md(),
                SkolrCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SkolrSpacing.lg,
                    vertical: SkolrSpacing.sm,
                  ),
                  child: AnimatedBuilder(
                    animation: SkolrThemeController.instance,
                    builder: (context, _) {
                      final mode = SkolrThemeController.instance.mode;
                      return SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Dark Mode',
                          style:
                              SkolrTypography.bodyLarge(color: cs.onSurface),
                        ),
                        subtitle: Text(
                          'Skolr looks best in the dark',
                          style: SkolrTypography.bodySmall(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        value: mode == ThemeMode.dark,
                        onChanged: (v) {
                          SkolrThemeController.instance.setMode(
                            v ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                      );
                    },
                  ),
                ),
                const SkolrGap.xxl(),

                // ── Section: Danger Zone ──────────────────────
                _SectionLabel(
                  icon: Icons.warning_amber_rounded,
                  label: 'DANGER ZONE',
                  tint: SkolrColors.danger,
                ),
                const SkolrGap.md(),
                Container(
                  decoration: BoxDecoration(
                    color: SkolrColors.danger.withValues(
                        alpha: brightness == Brightness.dark ? 0.06 : 0.04),
                    borderRadius: SkolrRadius.xl,
                    border: Border.all(
                      color: SkolrColors.danger.withValues(alpha: 0.3),
                    ),
                  ),
                  padding: const EdgeInsets.all(SkolrSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reset App',
                        style: SkolrTypography.titleMedium(
                          color: cs.onSurface,
                        ),
                      ),
                      const SkolrGap.xs(),
                      Text(
                        'Remove your institute setup and return to the '
                        'onboarding screen. This cannot be undone.',
                        style: SkolrTypography.bodyMedium(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SkolrGap.lg(),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: _resetApp,
                          icon: Icon(
                            Icons.restart_alt_rounded,
                            color: SkolrColors.danger,
                          ),
                          label: Text(
                            'Reset App',
                            style: SkolrTypography.labelLarge(
                              color: SkolrColors.danger,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: SkolrColors.danger.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: SkolrRadius.md,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Section label ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.label, this.tint});
  final IconData icon;
  final String label;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = tint ?? cs.onSurfaceVariant;
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SkolrGap.xs(),
        Text(label, style: SkolrTypography.labelSmall(color: color)),
      ],
    );
  }
}

// ─── Field label ────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(text, style: SkolrTypography.labelLarge(color: cs.onSurface));
  }
}

// ─── Type picker (segmented control style) ──────────────────────────────────

class _TypePicker extends StatelessWidget {
  const _TypePicker({required this.selected, required this.onChanged});
  final InstituteType selected;
  final ValueChanged<InstituteType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TypeOption(
            label: 'Coaching',
            icon: Icons.menu_book_rounded,
            selected: selected == InstituteType.coaching,
            onTap: () => onChanged(InstituteType.coaching),
          ),
        ),
        const SkolrGap.md(),
        Expanded(
          child: _TypeOption(
            label: 'School',
            icon: Icons.apartment_rounded,
            selected: selected == InstituteType.school,
            onTap: () => onChanged(InstituteType.school),
          ),
        ),
      ],
    );
  }
}

class _TypeOption extends StatelessWidget {
  const _TypeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
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
        child: AnimatedContainer(
          duration: SkolrMotion.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: SkolrSpacing.md,
            vertical: SkolrSpacing.md,
          ),
          decoration: BoxDecoration(
            gradient: selected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      SkolrColors.primary
                          .withValues(alpha: isDark ? 0.25 : 0.14),
                      SkolrColors.secondary
                          .withValues(alpha: isDark ? 0.12 : 0.06),
                    ],
                  )
                : null,
            color: selected
                ? null
                : (isDark
                    ? SkolrColors.midnight700.withValues(alpha: 0.6)
                    : SkolrColors.lightSurfaceAlt),
            borderRadius: SkolrRadius.md,
            border: Border.all(
              color: selected
                  ? SkolrColors.primary.withValues(alpha: 0.45)
                  : (isDark
                      ? SkolrColors.glassBorder
                      : SkolrColors.lightBorder),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? SkolrColors.primary : cs.onSurfaceVariant,
              ),
              const SkolrGap.sm(),
              Text(
                label,
                style: SkolrTypography.labelLarge(
                  color: selected ? cs.onSurface : cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}