import 'package:flutter/material.dart';

import '../../modules/students/student_model.dart';
import '../design_system/design_system.dart';
import 'skolr_avatar.dart';
import 'skolr_card.dart';

// ---------------------------------------------------------------------------
// StudentCard — premium row card for the students list.
//
// Visual recipe:
//   • Glass card surface
//   • SkolrAvatar (deterministic color per name)
//   • Name + batch + phone metadata
//   • Popup menu for delete
// ---------------------------------------------------------------------------

class StudentCard extends StatelessWidget {
  final StudentModel student;
  final VoidCallback? onDelete;

  const StudentCard({
    super.key,
    required this.student,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: SkolrSpacing.md),
      child: SkolrCard(
        padding: const EdgeInsets.all(SkolrSpacing.lg),
        child: Row(
          children: [
            SkolrAvatar(name: student.name, size: SkolrAvatarSize.lg),
            const SkolrGap.lg(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: SkolrTypography.titleMedium(color: cs.onSurface),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.class_outlined,
                        size: 13,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        student.batch,
                        style: SkolrTypography.bodyMedium(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 13,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        student.phone,
                        style: SkolrTypography.bodyMedium(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: cs.onSurfaceVariant,
              ),
              onSelected: (value) {
                if (value == 'delete') onDelete?.call();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: SkolrColors.danger,
                        size: 18,
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
    );
  }
}