import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/primary_button.dart';
import '../student_model.dart';
import '../student_provider.dart';

class AddStudentScreen extends ConsumerStatefulWidget {
  const AddStudentScreen({super.key});

  @override
  ConsumerState<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends ConsumerState<AddStudentScreen> {
  final _nameController = TextEditingController();
  final _batchController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _batchController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final batch = _batchController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || batch.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    ref.read(studentProvider.notifier).addStudent(
          StudentModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: name,
            batch: batch,
            phone: phone,
          ),
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 10),

              const Text('Student Details', style: AppTextStyles.heading),

              const SizedBox(height: 8),

              const Text(
                'Fill in the information below',
                style: AppTextStyles.subheading,
              ),

              const SizedBox(height: 30),

              CustomTextField(
                hintText: 'Full Name',
                controller: _nameController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Batch / Class',
                controller: _batchController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Phone Number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                text: 'Save Student',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
