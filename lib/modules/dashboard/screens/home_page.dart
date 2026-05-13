import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/widgets/dashboard_card.dart';
import 'settings_page.dart';

// ---------------------------------------------------------------------------
// HomePage — the "Welcome Back" dashboard.
//
// Visual recipe:
//   • Radial gradient background (deep midnight on dark, pale violet on light)
//   • Premium greeting with subtle gradient wash on "Welcome Back"
//   • Today's date eyebrow
//   • 4-card grid with staggered fade+rise entrance
//   • Cards are tappable — placeholder onTap; wire these to real routes later
// ---------------------------------------------------------------------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _entryCtrl;

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
    _entryCtrl.dispose();
    super.dispose();
  }

  String _greetingForHour(int h) {
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _formattedDate(DateTime d) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final now = DateTime.now();
    final greeting = _greetingForHour(now.hour);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: SkolrGradients.pageBackground(brightness),
        ),
        child: SafeArea(
          child: ListView(
            
            padding: const EdgeInsets.fromLTRB(
              SkolrSpacing.xl,
              SkolrSpacing.xl,
              SkolrSpacing.xl,
              SkolrSpacing.xxxxl + SkolrSpacing.xl, // room for bottom nav
            ),
            children: [
              // ── Top bar ───────────────────────────────────────────────────────────
_Entry(
  controller: _entryCtrl,
  start: 0.0,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // App logo / wordmark
      Text(
        'Skolr',
        style: SkolrTypography.headlineMedium(
          color: cs.onSurface,
        ).copyWith(fontWeight: FontWeight.w700),
      ),
      // Settings button
      IconButton(
        icon: Icon(
          Icons.settings_outlined,
          color: cs.onSurfaceVariant,
        ),
        tooltip: 'Settings',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        ),
      ),
    ],
  ),
),
const SkolrGap.md(),

// ── Date eyebrow (already exists, leave as-is) ────────────────────────
              // ── Date eyebrow ───────────────────────────────────────────
              _Entry(
                controller: _entryCtrl,
                start: 0.0,
                child: Text(
                  _formattedDate(now).toUpperCase(),
                  style: SkolrTypography.labelSmall(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
              const SkolrGap.sm(),

              // ── Greeting ──────────────────────────────────────────────
              _Entry(
                controller: _entryCtrl,
                start: 0.05,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$greeting,\n',
                              style: SkolrTypography.headlineLarge(
                                color: cs.onSurface,
                              ),
                            ),
                            TextSpan(
                              text: 'Welcome back',
                              style: SkolrTypography.headlineLarge(
                                color: SkolrColors.primary,
                              ).copyWith(
                                foreground: Paint()
                                  ..shader = SkolrGradients.brand.createShader(
                                    const Rect.fromLTWH(0, 0, 300, 70),
                                  ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SkolrGap.sm(),
                    Padding(
                      padding: const EdgeInsets.only(top: SkolrSpacing.lg),
                      child: Text(
                        '👋',
                        style: SkolrTypography.headlineLarge(),
                      ),
                    ),
                  ],
                ),
              ),
              const SkolrGap.sm(),

              // ── Subhead ───────────────────────────────────────────────
              _Entry(
                controller: _entryCtrl,
                start: 0.1,
                child: Text(
                  "Here's what's happening at your institute today.",
                  style: SkolrTypography.bodyLarge(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
              const SkolrGap.xxl(),

              // ── Hero stat row ─────────────────────────────────────────
              _Entry(
                controller: _entryCtrl,
                start: 0.15,
                child: const DashboardCard(
                  title: 'Pending Fees',
                  value: '₹48,250',
                  icon: Icons.account_balance_wallet_rounded,
                  hero: true,
                  trend: '8 students overdue',
                ),
              ),
              const SkolrGap.lg(),

              // ── Stat grid ─────────────────────────────────────────────
GridView.count(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisCount: 2,
  crossAxisSpacing: SkolrSpacing.lg,
  mainAxisSpacing: SkolrSpacing.lg,
  childAspectRatio: 1.2, // ← increase until all 4 cards look identical
  children: [
    _Entry(
      controller: _entryCtrl,
      start: 0.2,
      child: DashboardCard(
        title: 'Students',
        value: '1,248',
        icon: Icons.people_alt_rounded,
        iconTint: SkolrColors.primary,
        // ← remove trend and trendUp entirely
        onTap: () {},
      ),
    ),
    _Entry(
      controller: _entryCtrl,
      start: 0.25,
      child: DashboardCard(
        title: 'Attendance',
        value: '92%',
        icon: Icons.check_circle_rounded,
        iconTint: SkolrColors.success,
        // ← remove trend and trendUp entirely
        onTap: () {},
      ),
    ),
    _Entry(
      controller: _entryCtrl,
      start: 0.3,
      child: DashboardCard(
        title: 'Teachers',
        value: '24',
        icon: Icons.school_rounded,
        iconTint: SkolrColors.secondary,
        onTap: () {},
      ),
    ),
    _Entry(
      controller: _entryCtrl,
      start: 0.35,
      child: DashboardCard(
        title: 'Collected',
        value: '₹2.4L',
        icon: Icons.trending_up_rounded,
        iconTint: SkolrColors.warning,
        // ← remove trend entirely
        onTap: () {},
      ),
    ),
  ],
),

              const SkolrGap.xxl(),

              // ── Quick actions section header ──────────────────────────
              _Entry(
                controller: _entryCtrl,
                start: 0.4,
                child: Text(
                  'QUICK ACTIONS',
                  style: SkolrTypography.labelSmall(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
              const SkolrGap.md(),

              _Entry(
                controller: _entryCtrl,
                start: 0.45,
                child: const _QuickActionsRow(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Quick actions row ──────────────────────────────────────────────────────

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            label: 'Mark\nAttendance',
            icon: Icons.fact_check_rounded,
            tint: SkolrColors.success,
            onTap: () {},
          ),
        ),
        const SkolrGap.md(),
        Expanded(
          child: _QuickAction(
            label: 'Add\nStudent',
            icon: Icons.person_add_rounded,
            tint: SkolrColors.primary,
            onTap: () {},
          ),
        ),
        const SkolrGap.md(),
        Expanded(
          child: _QuickAction(
            label: 'Send\nReminder',
            icon: Icons.send_rounded,
            tint: SkolrColors.warning,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.tint,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color tint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: SkolrRadius.xl,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                tint.withValues(alpha: isDark ? 0.18 : 0.10),
                tint.withValues(alpha: isDark ? 0.06 : 0.03),
              ],
            ),
            borderRadius: SkolrRadius.xl,
            border: Border.all(
              color: tint.withValues(alpha: isDark ? 0.3 : 0.18),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: SkolrSpacing.md,
            vertical: SkolrSpacing.lg,
          ),
          child: Column(
            children: [
              Icon(icon, color: tint, size: 24),
              const SkolrGap.sm(),
              Text(
                label,
                textAlign: TextAlign.center,
                style: SkolrTypography.labelMedium(color: cs.onSurface),
              ),
            ],
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

  /// Animation start, 0..1 of the controller. Use to stagger items.
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