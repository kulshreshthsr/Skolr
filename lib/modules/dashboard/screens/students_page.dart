import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/student_card.dart';
import '../../students/screens/add_student_screen.dart';
import '../../students/student_provider.dart';

class StudentsPage extends ConsumerWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddStudentScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 10),

              const Text('Students', style: AppTextStyles.heading),

              const SizedBox(height: 20),

              const TextField(
                decoration: InputDecoration(
                  hintText: 'Search students...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: students.isEmpty
                    ? const Center(
                        child: Text(
                          'No students yet.\nTap + to add one.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.subheading,
                        ),
                      )
                    : ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          return StudentCard(
                            student: student,
                            onDelete: () {
                              ref
                                  .read(studentProvider.notifier)
                                  .removeStudent(student.id);
                            },
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
