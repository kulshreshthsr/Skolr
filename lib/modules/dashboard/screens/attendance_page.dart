import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/attendance_card.dart';
import '../../attendance/attendance_provider.dart';
import '../../students/student_provider.dart';

class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
  final _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final students = ref.read(studentProvider);
      ref.read(attendanceProvider.notifier).initializeDay(students, _today);
    });
  }

  String _formatDate(DateTime d) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
    ];
    return '${weekdays[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final allRecords = ref.watch(attendanceProvider);
    final students = ref.watch(studentProvider);

    final todayKey = _dateKey(_today);
    final todayRecords =
        allRecords.where((r) => r.dateKey == todayKey).toList();

    final presentCount = todayRecords.where((r) => r.isPresent).length;
    final absentCount = todayRecords.length - presentCount;

    final batchMap = {for (final s in students) s.id: s.batch};

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Attendance', style: AppTextStyles.heading),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(_today),
                    style: AppTextStyles.subheading,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Summary Row ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _StatCard(
                    label: 'Total',
                    value: todayRecords.length,
                    color: AppColors.primary,
                    icon: Icons.people_rounded,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'Present',
                    value: presentCount,
                    color: AppColors.success,
                    icon: Icons.check_circle_rounded,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'Absent',
                    value: absentCount,
                    color: AppColors.error,
                    icon: Icons.cancel_rounded,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Quick-action row ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _QuickActionButton(
                      label: 'Mark All Present',
                      color: AppColors.success,
                      onTap: () => ref
                          .read(attendanceProvider.notifier)
                          .markAllPresent(_today),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionButton(
                      label: 'Mark All Absent',
                      color: AppColors.error,
                      onTap: () => ref
                          .read(attendanceProvider.notifier)
                          .markAllAbsent(_today),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Student List ─────────────────────────────────────────
            Expanded(
              child: todayRecords.isEmpty
                  ? const Center(
                      child: Text(
                        'No students found.\nAdd students first.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.subheading,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: todayRecords.length,
                      itemBuilder: (context, index) {
                        final record = todayRecords[index];
                        return AttendanceCard(
                          record: record,
                          batch: batchMap[record.studentId] ?? '',
                          onToggle: () => ref
                              .read(attendanceProvider.notifier)
                              .toggleAttendance(record.studentId, _today),
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

// ── Local widgets ────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.subheading.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
