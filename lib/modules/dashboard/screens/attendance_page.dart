import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/widgets/attendance_card.dart';
import '../../attendance/attendance_provider.dart';
import '../../students/student_provider.dart';

// ---------------------------------------------------------------------------
// AttendancePage — daily attendance roster.
//
// Visual recipe:
//   • Page gradient background
//   • Date eyebrow + "Attendance" headline
//   • 3-card stat row (Total / Present / Absent) using glass status decoration
//   • Quick action chips: Mark All Present / Mark All Absent
//   • Student list with toggle switches
// ---------------------------------------------------------------------------

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
      'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY',
      'FRIDAY', 'SATURDAY', 'SUNDAY',
    ];
    return '${weekdays[d.weekday - 1]} · ${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final cs = Theme.of(context).colorScheme;

    final allRecords = ref.watch(attendanceProvider);
    final students = ref.watch(studentProvider);

    final todayKey = _dateKey(_today);
    final todayRecords =
        allRecords.where((r) => r.dateKey == todayKey).toList();

    final presentCount = todayRecords.where((r) => r.isPresent).length;
    final absentCount = todayRecords.length - presentCount;

    final batchMap = {for (final s in students) s.id: s.batch};

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: SkolrGradients.pageBackground(brightness),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────────────────
              Padding(
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
                      _formatDate(_today),
                      style: SkolrTypography.labelSmall(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SkolrGap.xs(),
                    Text(
                      'Attendance',
                      style: SkolrTypography.headlineLarge(
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SkolrGap.lg(),

              // ── Stat row ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SkolrSpacing.xl,
                ),
                child: Row(
                  children: [
                    _StatCard(
                      label: 'Total',
                      value: todayRecords.length,
                      tint: SkolrColors.primary,
                      icon: Icons.people_alt_rounded,
                    ),
                    const SkolrGap.md(),
                    _StatCard(
                      label: 'Present',
                      value: presentCount,
                      tint: SkolrColors.success,
                      icon: Icons.check_circle_rounded,
                    ),
                    const SkolrGap.md(),
                    _StatCard(
                      label: 'Absent',
                      value: absentCount,
                      tint: SkolrColors.danger,
                      icon: Icons.cancel_rounded,
                    ),
                  ],
                ),
              ),
              const SkolrGap.lg(),

              // ── Quick actions ──────────────────────────────────
              if (todayRecords.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SkolrSpacing.xl,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _QuickActionButton(
                          label: 'Mark All Present',
                          icon: Icons.done_all_rounded,
                          tint: SkolrColors.success,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            ref
                                .read(attendanceProvider.notifier)
                                .markAllPresent(_today);
                          },
                        ),
                      ),
                      const SkolrGap.md(),
                      Expanded(
                        child: _QuickActionButton(
                          label: 'Mark All Absent',
                          icon: Icons.remove_done_rounded,
                          tint: SkolrColors.danger,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            ref
                                .read(attendanceProvider.notifier)
                                .markAllAbsent(_today);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              const SkolrGap.lg(),

              // ── Roster ─────────────────────────────────────────
              Expanded(
                child: todayRecords.isEmpty
                    ? _EmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          SkolrSpacing.xl,
                          0,
                          SkolrSpacing.xl,
                          SkolrSpacing.xxxxl + SkolrSpacing.xl,
                        ),
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
      ),
    );
  }
}

// ─── Stat card (glass) ──────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.tint,
    required this.icon,
  });

  final String label;
  final int value;
  final Color tint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SkolrSpacing.md,
          vertical: SkolrSpacing.lg,
        ),
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
          children: [
            Icon(icon, color: tint, size: 22),
            const SkolrGap.sm(),
            Text(
              '$value',
              style: SkolrTypography.metricLarge(color: cs.onSurface)
                  .copyWith(fontSize: 24),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: SkolrTypography.labelMedium(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Quick action button ────────────────────────────────────────────────────

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: SkolrRadius.md,
        child: Ink(
          decoration: BoxDecoration(
            color: tint.withValues(alpha: isDark ? 0.14 : 0.08),
            borderRadius: SkolrRadius.md,
            border: Border.all(
              color: tint.withValues(alpha: isDark ? 0.35 : 0.25),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: SkolrSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: tint, size: 16),
              const SkolrGap.sm(),
              Text(
                label,
                style: SkolrTypography.labelLarge(color: tint),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Empty state ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
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
                Icons.fact_check_outlined,
                color: SkolrColors.primary,
                size: 36,
              ),
            ),
            const SkolrGap.lg(),
            Text(
              'No students yet',
              style: SkolrTypography.titleLarge(color: cs.onSurface),
            ),
            const SkolrGap.xs(),
            Text(
              'Add students before marking attendance.',
              style: SkolrTypography.bodyMedium(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}