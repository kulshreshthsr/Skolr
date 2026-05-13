import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/services/whatsapp_service.dart';
import '../../../core/widgets/fee_card.dart';
import '../../fees/fee_provider.dart';
import '../../fees/screens/add_edit_fee_screen.dart';
import '../../institute/institute_provider.dart';
import '../../students/student_provider.dart';

// ---------------------------------------------------------------------------
// FeesPage — fee management with WhatsApp reminders.
//
// Visual recipe:
//   • Page gradient background
//   • "Fees" headline + count
//   • Hero pending-fees gradient card (the standout stat)
//   • 2×2 grid of secondary stats with glass treatment
//   • Fee list with status-colored borders
//   • Gradient FAB with glow
// ---------------------------------------------------------------------------

class FeesPage extends ConsumerWidget {
  const FeesPage({super.key});

  String _currency(double v) {
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final cs = Theme.of(context).colorScheme;

    final fees = ref.watch(feeProvider);
    final students = ref.watch(studentProvider);
    final instituteName =
        ref.watch(instituteProvider).institute?.instituteName ?? 'Skolr';
    final batchMap = {for (final s in students) s.id: s.batch};
    final phoneMap = {for (final s in students) s.id: s.phone};

    final totalCollected =
        fees.fold<double>(0, (sum, f) => sum + f.paidAmount);
    final totalPending = fees.fold<double>(0, (sum, f) => sum + f.dueAmount);
    final paidCount = fees.where((f) => f.isPaid).length;
    final unpaidCount = fees.where((f) => !f.isPaid).length;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      floatingActionButton: _GradientFab(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditFeeScreen()),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: SkolrGradients.pageBackground(brightness),
        ),
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              // ── Header ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    SkolrSpacing.xl,
                    SkolrSpacing.xl,
                    SkolrSpacing.xl,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fees',
                        style: SkolrTypography.headlineLarge(
                          color: cs.onSurface,
                        ),
                      ),
                      const SkolrGap.xs(),
                      Text(
                        '${fees.length} record${fees.length == 1 ? '' : 's'}',
                        style: SkolrTypography.bodyMedium(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Hero pending card ──────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(SkolrSpacing.xl),
                  child: _HeroPendingCard(
                    pendingAmount: _currency(totalPending),
                    pendingStudents: unpaidCount,
                  ),
                ),
              ),

              // ── Secondary stats grid ───────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: SkolrSpacing.xl),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: SkolrSpacing.md,
                    mainAxisSpacing: SkolrSpacing.md,
                    childAspectRatio: 0.95,
                  ),
                  delegate: SliverChildListDelegate([
                    _MiniStat(
                      label: 'Collected',
                      value: _currency(totalCollected),
                      tint: SkolrColors.success,
                      icon: Icons.account_balance_wallet_rounded,
                    ),
                    _MiniStat(
                      label: 'Paid',
                      value: '$paidCount',
                      tint: SkolrColors.primary,
                      icon: Icons.check_circle_rounded,
                    ),
                    _MiniStat(
                      label: 'Unpaid',
                      value: '$unpaidCount',
                      tint: SkolrColors.danger,
                      icon: Icons.cancel_rounded,
                    ),
                  ]),
                ),
              ),

              const SliverToBoxAdapter(child: SkolrGap.xl()),

              // ── List header ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: SkolrSpacing.xl),
                  child: Text(
                    'ALL RECORDS',
                    style: SkolrTypography.labelSmall(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SkolrGap.md()),

              // ── Fee list ───────────────────────────────────────
              if (fees.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    SkolrSpacing.xl,
                    0,
                    SkolrSpacing.xl,
                    SkolrSpacing.xxxxl + SkolrSpacing.xl,
                  ),
                  sliver: SliverList.builder(
                    itemCount: fees.length,
                    itemBuilder: (context, index) {
                      final fee = fees[index];
                      return FeeCard(
                        fee: fee,
                        batch: batchMap[fee.studentId] ?? '',
                        onMarkPaid: () =>
                            ref.read(feeProvider.notifier).markPaid(fee.id),
                        onEdit: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditFeeScreen(existingFee: fee),
                          ),
                        ),
                        onDelete: () =>
                            ref.read(feeProvider.notifier).removeFee(fee.id),
                        onSendReminder: fee.isPaid
                            ? null
                            : () => WhatsAppService.sendReminder(
                                  context: context,
                                  phone: phoneMap[fee.studentId] ?? '',
                                  message:
                                      WhatsAppService.buildReminderMessage(
                                    studentName: fee.studentName,
                                    dueAmount: fee.dueAmount,
                                    dueDate: fee.dueDate,
                                    instituteName: instituteName,
                                  ),
                                ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Hero pending fees card ─────────────────────────────────────────────────

class _HeroPendingCard extends StatelessWidget {
  const _HeroPendingCard({
    required this.pendingAmount,
    required this.pendingStudents,
  });
  final String pendingAmount;
  final int pendingStudents;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SkolrSpacing.xl),
      decoration: BoxDecoration(
        gradient: SkolrGradients.brand,
        borderRadius: SkolrRadius.xl,
        boxShadow: SkolrShadows.brandGlowSoft,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PENDING FEES',
                  style: SkolrTypography.labelSmall(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SkolrGap.sm(),
                Text(
                  pendingAmount,
                  style: SkolrTypography.metricHero(color: Colors.white),
                ),
                const SkolrGap.sm(),
                Text(
                  '$pendingStudents student${pendingStudents == 1 ? '' : 's'} pending',
                  style: SkolrTypography.bodyMedium(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: SkolrRadius.lg,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.pending_actions_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mini stat card (glass) ─────────────────────────────────────────────────

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.tint,
    required this.icon,
  });

  final String label;
  final String value;
  final Color tint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(SkolrSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tint.withValues(alpha: isDark ? 0.18 : 0.10),
            tint.withValues(alpha: isDark ? 0.06 : 0.03),
          ],
        ),
        borderRadius: SkolrRadius.lg,
        border: Border.all(
          color: tint.withValues(alpha: isDark ? 0.3 : 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: tint, size: 20),
          const Spacer(),
          Text(
            value,
            style: SkolrTypography.titleLarge(color: cs.onSurface)
                .copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: SkolrTypography.bodySmall(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ─── Empty state ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SkolrSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: SkolrColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.currency_rupee_rounded,
                color: SkolrColors.primary,
                size: 36,
              ),
            ),
            const SkolrGap.lg(),
            Text(
              'No fee records yet',
              style: SkolrTypography.titleLarge(color: cs.onSurface),
            ),
            const SkolrGap.xs(),
            Text(
              'Tap the + button to create your first fee record.',
              style: SkolrTypography.bodyMedium(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Gradient FAB ───────────────────────────────────────────────────────────

class _GradientFab extends StatelessWidget {
  const _GradientFab({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: SkolrSpacing.xxxxl),
      decoration: BoxDecoration(
        gradient: SkolrGradients.brand,
        borderRadius: SkolrRadius.xl,
        boxShadow: SkolrShadows.brandGlowSoft,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: SkolrRadius.xl,
          child: const SizedBox(
            width: 56,
            height: 56,
            child: Icon(Icons.add_rounded, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}