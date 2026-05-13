import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/skolr_card.dart';
import '../../../core/widgets/skolr_text_field.dart';
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

  String? _nameError;
  String? _batchError;
  String? _phoneError;

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

    setState(() {
      _nameError = name.isEmpty ? 'Name is required' : null;
      _batchError = batch.isEmpty ? 'Batch is required' : null;
      _phoneError = phone.isEmpty ? 'Phone is required' : null;
    });

    if (_nameError != null || _batchError != null || _phoneError != null) {
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
    final brightness = Theme.of(context).brightness;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: SkolrGradients.pageBackground(brightness),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(SkolrSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkolrGap.md(),
                Text(
                  'Student Details',
                  style: SkolrTypography.headlineLarge(color: cs.onSurface),
                ),
                const SkolrGap.xs(),
                Text(
                  'Fill in the information below',
                  style: SkolrTypography.bodyLarge(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SkolrGap.xxl(),

                SkolrCard(
                  padding: const EdgeInsets.all(SkolrSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel('Full Name', required: true),
                      const SkolrGap.sm(),
                      SkolrTextField(
                        controller: _nameController,
                        hint: 'e.g. Riya Sharma',
                        error: _nameError,
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        onChanged: (_) {
                          if (_nameError != null) {
                            setState(() => _nameError = null);
                          }
                        },
                      ),
                      const SkolrGap.lg(),
                      _FieldLabel('Batch / Class', required: true),
                      const SkolrGap.sm(),
                      SkolrTextField(
                        controller: _batchController,
                        hint: 'e.g. JEE 2026 Batch A',
                        error: _batchError,
                        prefixIcon: const Icon(Icons.class_outlined),
                        textInputAction: TextInputAction.next,
                        onChanged: (_) {
                          if (_batchError != null) {
                            setState(() => _batchError = null);
                          }
                        },
                      ),
                      const SkolrGap.lg(),
                      _FieldLabel('Phone Number', required: true),
                      const SkolrGap.sm(),
                      SkolrTextField(
                        controller: _phoneController,
                        hint: '+91 9876543210',
                        error: _phoneError,
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone_outlined),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _save(),
                        onChanged: (_) {
                          if (_phoneError != null) {
                            setState(() => _phoneError = null);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SkolrGap.xxl(),

                PrimaryButton(
                  text: 'Save Student',
                  icon: Icons.check_rounded,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {this.required = false});
  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(text, style: SkolrTypography.labelLarge(color: cs.onSurface)),
        if (required) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: SkolrTypography.labelLarge(color: SkolrColors.danger),
          ),
        ],
      ],
    );
  }
}