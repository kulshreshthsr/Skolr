import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/fee_card.dart';
import '../../fees/fee_provider.dart';
import '../../fees/screens/add_edit_fee_screen.dart';
import '../../students/student_provider.dart';

class FeesPage extends ConsumerWidget {
  const FeesPage({super.key});

  String _currency(double v) {
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fees = ref.watch(feeProvider);
    final students = ref.watch(studentProvider);
    final batchMap = {for (final s in students) s.id: s.batch};

    final totalCollected =
        fees.fold<double>(0, (sum, f) => sum + f.paidAmount);
    final totalPending =
        fees.fold<double>(0, (sum, f) => sum + f.dueAmount);
    final paidCount = fees.where((f) => f.isPaid).length;
    final unpaidCount = fees.where((f) => !f.isPaid).length;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditFeeScreen()),
        ),
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fees', style: AppTextStyles.heading),
                  const SizedBox(height: 4),
                  Text(
                    '${fees.length} fee record${fees.length == 1 ? '' : 's'}',
                    style: AppTextStyles.subheading,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Summary Grid (2 × 2) ────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      _SummaryCard(
                        label: 'Collected',
                        value: _currency(totalCollected),
                        color: AppColors.success,
                        icon: Icons.account_balance_wallet_rounded,
                      ),
                      const SizedBox(width: 12),
                      _SummaryCard(
                        label: 'Pending',
                        value: _currency(totalPending),
                        color: AppColors.warning,
                        icon: Icons.pending_actions_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _SummaryCard(
                        label: 'Paid',
                        value: '$paidCount student${paidCount == 1 ? '' : 's'}',
                        color: AppColors.primary,
                        icon: Icons.check_circle_rounded,
                      ),
                      const SizedBox(width: 12),
                      _SummaryCard(
                        label: 'Unpaid',
                        value:
                            '$unpaidCount student${unpaidCount == 1 ? '' : 's'}',
                        color: AppColors.error,
                        icon: Icons.cancel_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Fee List ────────────────────────────────────────
            Expanded(
              child: fees.isEmpty
                  ? const Center(
                      child: Text(
                        'No fee records yet.\nTap + to add one.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.subheading,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
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
                              builder: (_) =>
                                  AddEditFeeScreen(existingFee: fee),
                            ),
                          ),
                          onDelete: () =>
                              ref.read(feeProvider.notifier).removeFee(fee.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Local widget ─────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
