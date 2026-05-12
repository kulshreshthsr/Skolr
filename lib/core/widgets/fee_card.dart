import 'package:flutter/material.dart';

import '../../modules/fees/fee_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class FeeCard extends StatelessWidget {
  final FeeModel fee;
  final String batch;
  final VoidCallback onMarkPaid;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FeeCard({
    super.key,
    required this.fee,
    required this.batch,
    required this.onMarkPaid,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String _currency(double v) => '₹${v.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final isPaid = fee.isPaid;
    final isOverdue =
        !isPaid && fee.dueDate.isBefore(DateTime.now());

    final statusColor = isPaid
        ? AppColors.success
        : isOverdue
            ? AppColors.error
            : AppColors.warning;

    final statusLabel = isPaid
        ? 'Paid'
        : isOverdue
            ? 'Overdue'
            : 'Pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isPaid
              ? AppColors.success.withValues(alpha: 0.2)
              : isOverdue
                  ? AppColors.error.withValues(alpha: 0.2)
                  : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: isPaid
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    fee.studentName[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isPaid ? AppColors.success : AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fee.studentName,
                        style: AppTextStyles.heading.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        batch,
                        style: AppTextStyles.subheading.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),

                // Status badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),

                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.textSecondary,
                  ),
                  onSelected: (v) {
                    if (v == 'edit') onEdit();
                    if (v == 'delete') onDelete();
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded,
                              size: 18, color: AppColors.error),
                          SizedBox(width: 8),
                          Text('Delete',
                              style: TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Amounts ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _AmountColumn(
                    label: 'Total',
                    value: _currency(fee.totalAmount),
                    color: AppColors.textPrimary,
                  ),
                  Container(width: 1, height: 36, color: AppColors.border),
                  _AmountColumn(
                    label: 'Paid',
                    value: _currency(fee.paidAmount),
                    color: AppColors.success,
                  ),
                  Container(width: 1, height: 36, color: AppColors.border),
                  _AmountColumn(
                    label: 'Due',
                    value: _currency(fee.dueAmount),
                    color: fee.dueAmount > 0 ? AppColors.error : AppColors.success,
                  ),
                ],
              ),
            ),
          ),

          // ── Divider ────────────────────────────────────────────
          const Divider(height: 1, color: AppColors.border),

          // ── Footer ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Due ${_formatDate(fee.dueDate)}',
                  style: AppTextStyles.subheading.copyWith(fontSize: 13),
                ),

                const Spacer(),

                if (!isPaid)
                  GestureDetector(
                    onTap: onMarkPaid,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.4)),
                      ),
                      child: const Text(
                        'Mark Paid',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _AmountColumn({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
