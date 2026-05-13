import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/widgets/skolr_text_field.dart';
import '../../../core/widgets/student_card.dart';
import '../../students/screens/add_student_screen.dart';
import '../../students/student_provider.dart';

// ---------------------------------------------------------------------------
// StudentsPage — directory of students with search.
//
// Visual recipe:
//   • Page-level radial gradient background (consistent across tabs)
//   • Headline with gradient text accent
//   • Counter chip showing total
//   • SkolrTextField for search with prefix icon
//   • Empty state with illustration and CTA
//   • Gradient FAB with glow
//   • Bottom padding for SkolrBottomNav clearance
// ---------------------------------------------------------------------------

class StudentsPage extends ConsumerStatefulWidget {
  const StudentsPage({super.key});

  @override
  ConsumerState<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends ConsumerState<StudentsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final students = ref.watch(studentProvider);
    final brightness = Theme.of(context).brightness;
    final cs = Theme.of(context).colorScheme;

    final filtered = _query.trim().isEmpty
        ? students
        : students.where((s) {
            final q = _query.toLowerCase();
            return s.name.toLowerCase().contains(q) ||
                s.batch.toLowerCase().contains(q) ||
                s.phone.contains(q);
          }).toList();

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      floatingActionButton: _GradientFab(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddStudentScreen()),
          );
        },
      ),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Students',
                          style: SkolrTypography.headlineLarge(
                            color: cs.onSurface,
                          ),
                        ),
                        const SkolrGap.md(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SkolrSpacing.sm,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: SkolrColors.primary
                                  .withValues(alpha: 0.16),
                              borderRadius: SkolrRadius.full,
                            ),
                            child: Text(
                              '${students.length}',
                              style: SkolrTypography.labelMedium(
                                color: SkolrColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SkolrGap.xs(),
                    Text(
                      'Manage your enrolled students',
                      style: SkolrTypography.bodyLarge(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SkolrGap.lg(),

              // ── Search ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SkolrSpacing.xl,
                ),
                child: SkolrTextField(
                  hint: 'Search by name, batch, or phone',
                  prefixIcon: const Icon(Icons.search_rounded),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              const SkolrGap.md(),

              // ── List or empty state ────────────────────────────
              Expanded(
                child: filtered.isEmpty
                    ? _EmptyState(
                        hasStudents: students.isNotEmpty,
                        onAddTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddStudentScreen(),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          SkolrSpacing.xl,
                          0,
                          SkolrSpacing.xl,
                          SkolrSpacing.xxxxl + SkolrSpacing.xl,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final student = filtered[index];
                          return StudentCard(
                            student: student,
                            onDelete: () => ref
                                .read(studentProvider.notifier)
                                .removeStudent(student.id),
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

// ─── Empty state ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasStudents, required this.onAddTap});
  final bool hasStudents;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SkolrSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    SkolrColors.primary
                        .withValues(alpha: isDark ? 0.22 : 0.14),
                    SkolrColors.secondary
                        .withValues(alpha: isDark ? 0.1 : 0.05),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: SkolrColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.people_outline_rounded,
                color: SkolrColors.primary,
                size: 40,
              ),
            ),
            const SkolrGap.xl(),
            Text(
              hasStudents ? 'No matches found' : 'No students yet',
              style: SkolrTypography.titleLarge(color: cs.onSurface),
              textAlign: TextAlign.center,
            ),
            const SkolrGap.sm(),
            Text(
              hasStudents
                  ? 'Try a different search term.'
                  : 'Tap the + button to add your first student.',
              style: SkolrTypography.bodyMedium(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Gradient FAB with glow ─────────────────────────────────────────────────

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