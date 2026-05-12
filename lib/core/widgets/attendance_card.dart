import 'package:flutter/material.dart';

import '../../modules/attendance/attendance_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

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
    final isPresent = record.isPresent;
    final accentColor = isPresent ? AppColors.success : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: isPresent
              ? AppColors.success.withValues(alpha: 0.25)
              : AppColors.border,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: accentColor.withValues(alpha: 0.12),
            child: Text(
              record.studentName[0].toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.studentName,
                  style: AppTextStyles.heading.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 3),
                Text(
                  batch,
                  style: AppTextStyles.subheading.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Switch(
                value: isPresent,
                onChanged: (_) => onToggle(),
                activeThumbColor: AppColors.success,
                inactiveThumbColor: AppColors.error,
                inactiveTrackColor: AppColors.error.withValues(alpha: 0.2),
              ),
              Text(
                isPresent ? 'Present' : 'Absent',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
