import 'package:flutter/material.dart';

import '../../modules/attendance/attendance_model.dart';
import '../design_system/design_system.dart';
import 'skolr_avatar.dart';

// ---------------------------------------------------------------------------
// AttendanceCard — toggle row for marking present/absent.
//
// Visual recipe:
//   • Animated border color (green if present, red if absent)
//   • SkolrAvatar (auto-tinted by name)
//   • Switch toggle with haptic feedback
//   • Status label under switch ("Present" / "Absent")
// ---------------------------------------------------------------------------

class AttendanceCard extends StatelessWidget {
  final AttendanceModel record;
  final String batch;
  final VoidCallback onToggle;

  const AttendanceCard({
    super.key,
    required this.record,
    required this.batch,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPresent = record.isPresent;
    final accentColor =
        isPresent ? SkolrColors.success : SkolrColors.danger;

    return Padding(
      padding: const EdgeInsets.only(bottom: SkolrSpacing.sm),
      child: AnimatedContainer(
        duration: SkolrMotion.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: SkolrSpacing.lg,
          vertical: SkolrSpacing.md,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accentColor.withValues(alpha: isDark ? 0.10 : 0.06),
              accentColor.withValues(alpha: isDark ? 0.04 : 0.02),
            ],
          ),
          borderRadius: SkolrRadius.lg,
          border: Border.all(
            color: accentColor.withValues(alpha: isDark ? 0.35 : 0.25),
          ),
        ),
        child: Row(
          children: [
            SkolrAvatar(name: record.studentName, size: SkolrAvatarSize.md),
            const SkolrGap.md(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.studentName,
                    style: SkolrTypography.titleSmall(color: cs.onSurface),
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
            Column(
              children: [
                Switch(
                  value: isPresent,
                  onChanged: (_) => onToggle(),
                  activeThumbColor: Colors.white,
                  activeTrackColor: SkolrColors.success,
                  inactiveThumbColor: cs.onSurfaceVariant,
                  inactiveTrackColor:
                      SkolrColors.danger.withValues(alpha: 0.3),
                ),
                Text(
                  isPresent ? 'Present' : 'Absent',
                  style: SkolrTypography.labelMedium(color: accentColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}