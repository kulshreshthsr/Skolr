import 'package:flutter/material.dart';

import '../../modules/fees/fee_model.dart';
import '../design_system/design_system.dart';
import '../services/whatsapp_service.dart';
import 'skolr_avatar.dart';

// ---------------------------------------------------------------------------
// FeeCard — fee record row with status accent, amounts panel, and actions.
//
// Visual recipe:
//   • Glass card surface with status-tinted left accent bar
//   • SkolrAvatar with status-colored ring (green/red border)
//   • Status pill in top-right (Paid / Overdue / Pending)
//   • Inset "amounts panel" with Total/Paid/Due
//   • Action row at bottom: "Send Reminder" (WhatsApp green) + "Mark Paid"
// ---------------------------------------------------------------------------

class FeeCard extends StatelessWidget {
  final FeeModel fee;
  final String batch;
  final VoidCallback onMarkPaid;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onSendReminder;

  const FeeCard({
    super.key,
    required this.fee,
    required this.batch,
    required this.onMarkPaid,
    required this.onEdit,
    required this.onDelete,
    this.onSendReminder,
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
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isPaid = fee.isPaid;
    final isOverdue = !isPaid && fee.dueDate.isBefore(DateTime.now());

    final statusColor = isPaid
        ? SkolrColors.success
        : isOverdue
            ? SkolrColors.danger
            : SkolrColors.warning;

    final statusLabel = isPaid
        ? 'Paid'
        : isOverdue
            ? 'Overdue'
            : 'Pending';

    return Padding(
      padding: const EdgeInsets.only(bottom: SkolrSpacing.md),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0x261A0F3D),
                    const Color(0x141A0F3D),
                  ]
                : [Colors.white, const Color(0xFFFAFAFF)],
          ),
          borderRadius: SkolrRadius.xl,
          border: Border.all(
            color: statusColor.withValues(alpha: isDark ? 0.35 : 0.22),
          ),
          boxShadow: SkolrShadows.adaptiveSoft(
            Theme.of(context).brightness,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SkolrSpacing.lg,
                SkolrSpacing.lg,
                SkolrSpacing.sm,
                SkolrSpacing.md,
              ),
              child: Row(
                children: [
                  SkolrAvatar(
                    name: fee.studentName,
                    size: SkolrAvatarSize.md,
                  ),
                  const SkolrGap.md(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fee.studentName,
                          style: SkolrTypography.titleMedium(
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          batch,
                          style: SkolrTypography.bodySmall(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SkolrSpacing.sm,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.18),
                      borderRadius: SkolrRadius.full,
                    ),
                    child: Text(
                      statusLabel,
                      style: SkolrTypography.labelMedium(color: statusColor),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: cs.onSurfaceVariant,
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
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                              color: SkolrColors.danger,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Delete',
                              style: TextStyle(color: SkolrColors.danger),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Amounts ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SkolrSpacing.lg,
                0,
                SkolrSpacing.lg,
                SkolrSpacing.md,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: SkolrSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? SkolrColors.midnight700.withValues(alpha: 0.5)
                      : SkolrColors.lightSurfaceAlt,
                  borderRadius: SkolrRadius.md,
                ),
                child: Row(
                  children: [
                    _Amount(
                      label: 'Total',
                      value: _currency(fee.totalAmount),
                      color: cs.onSurface,
                    ),
                    _VerticalDivider(),
                    _Amount(
                      label: 'Paid',
                      value: _currency(fee.paidAmount),
                      color: SkolrColors.success,
                    ),
                    _VerticalDivider(),
                    _Amount(
                      label: 'Due',
                      value: _currency(fee.dueAmount),
                      color: fee.dueAmount > 0
                          ? SkolrColors.danger
                          : SkolrColors.success,
                    ),
                  ],
                ),
              ),
            ),

            // ── Due date row ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SkolrSpacing.lg,
                0,
                SkolrSpacing.lg,
                SkolrSpacing.md,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 13,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Due ${_formatDate(fee.dueDate)}',
                    style: SkolrTypography.bodyMedium(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // ── Actions (only when unpaid) ──────────────────────
            if (!isPaid)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  SkolrSpacing.lg,
                  0,
                  SkolrSpacing.lg,
                  SkolrSpacing.lg,
                ),
                child: Row(
                  children: [
                    if (onSendReminder != null) ...[
                      Expanded(
                        child: _ActionButton(
                          label: 'Send Reminder',
                          icon: Icons.chat_rounded,
                          color: WhatsAppService.brandGreen,
                          onTap: onSendReminder!,
                        ),
                      ),
                      const SkolrGap.sm(),
                    ],
                    Expanded(
                      child: _ActionButton(
                        label: 'Mark Paid',
                        icon: Icons.check_circle_outline_rounded,
                        color: SkolrColors.success,
                        onTap: onMarkPaid,
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

class _Amount extends StatelessWidget {
  const _Amount({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: SkolrTypography.titleSmall(color: color)
                .copyWith(fontWeight: FontWeight.w700),
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

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(width: 1, height: 32, color: cs.outlineVariant);
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: SkolrRadius.md,
        child: Ink(
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.14 : 0.08),
            borderRadius: SkolrRadius.md,
            border: Border.all(
              color: color.withValues(alpha: isDark ? 0.4 : 0.3),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: SkolrSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 15),
              const SizedBox(width: 6),
              Text(
                label,
                style: SkolrTypography.labelLarge(color: color)
                    .copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}