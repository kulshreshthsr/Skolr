import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/primary_button.dart';
import '../../students/student_provider.dart';
import '../fee_model.dart';
import '../fee_provider.dart';

class AddEditFeeScreen extends ConsumerStatefulWidget {
  final FeeModel? existingFee;

  const AddEditFeeScreen({super.key, this.existingFee});

  @override
  ConsumerState<AddEditFeeScreen> createState() => _AddEditFeeScreenState();
}

class _AddEditFeeScreenState extends ConsumerState<AddEditFeeScreen> {
  String? _selectedStudentId;
  String _selectedStudentName = '';
  final _totalCtrl = TextEditingController();
  final _paidCtrl = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));
  bool _isPaid = false;

  bool get _isEditing => widget.existingFee != null;

  static const _labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  @override
  void initState() {
    super.initState();
    final f = widget.existingFee;
    if (f != null) {
      _selectedStudentId = f.studentId;
      _selectedStudentName = f.studentName;
      _totalCtrl.text = f.totalAmount.toStringAsFixed(0);
      _paidCtrl.text = f.paidAmount.toStringAsFixed(0);
      _dueDate = f.dueDate;
      _isPaid = f.isPaid;
    }
  }

  @override
  void dispose() {
    _totalCtrl.dispose();
    _paidCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _save() {
    if (_selectedStudentId == null) {
      _showError('Please select a student.');
      return;
    }

    final total = double.tryParse(_totalCtrl.text.trim()) ?? 0;
    final paid = double.tryParse(_paidCtrl.text.trim()) ?? 0;

    if (total <= 0) {
      _showError('Total amount must be greater than 0.');
      return;
    }
    if (paid > total) {
      _showError('Paid amount cannot exceed total amount.');
      return;
    }

    final isPaid = _isPaid || paid >= total;

    final fee = FeeModel(
      id: _isEditing
          ? widget.existingFee!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: _selectedStudentId!,
      studentName: _selectedStudentName,
      totalAmount: total,
      paidAmount: paid,
      dueDate: _dueDate,
      isPaid: isPaid,
    );

    if (_isEditing) {
      ref.read(feeProvider.notifier).updateFee(fee);
    } else {
      ref.read(feeProvider.notifier).addFee(fee);
    }

    Navigator.pop(context);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final students = ref.watch(studentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Fee Record' : 'Add Fee Record'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Text(
                _isEditing ? 'Edit Fee Record' : 'New Fee Record',
                style: AppTextStyles.heading,
              ),

              const SizedBox(height: 8),

              const Text(
                'Fill in the fee details below',
                style: AppTextStyles.subheading,
              ),

              const SizedBox(height: 30),

              // ── Student ───────────────────────────────────────
              const Text('Student', style: _labelStyle),
              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                initialValue: students.any((s) => s.id == _selectedStudentId)
                    ? _selectedStudentId
                    : null,
                decoration: const InputDecoration(hintText: 'Select student'),
                items: students
                    .map(
                      (s) => DropdownMenuItem(
                        value: s.id,
                        child: Text('${s.name} — ${s.batch}'),
                      ),
                    )
                    .toList(),
                onChanged: students.isEmpty
                    ? null
                    : (value) {
                        if (value == null) return;
                        final s = students.firstWhere((s) => s.id == value);
                        setState(() {
                          _selectedStudentId = value;
                          _selectedStudentName = s.name;
                        });
                      },
              ),

              if (students.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'No students found. Add students first.',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.error),
                  ),
                ),

              const SizedBox(height: 20),

              // ── Total Amount ──────────────────────────────────
              const Text('Total Amount (₹)', style: _labelStyle),
              const SizedBox(height: 8),

              CustomTextField(
                hintText: 'e.g. 15000',
                controller: _totalCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
              ),

              const SizedBox(height: 20),

              // ── Paid Amount ───────────────────────────────────
              const Text('Paid Amount (₹)', style: _labelStyle),
              const SizedBox(height: 8),

              CustomTextField(
                hintText: 'e.g. 5000',
                controller: _paidCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
              ),

              const SizedBox(height: 20),

              // ── Due Date ──────────────────────────────────────
              const Text('Due Date', style: _labelStyle),
              const SizedBox(height: 8),

              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(_dueDate),
                        style: AppTextStyles.inputText,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Mark Paid toggle ──────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mark as Fully Paid',
                      style: AppTextStyles.inputText,
                    ),
                    Switch(
                      value: _isPaid,
                      onChanged: (val) {
                        setState(() {
                          _isPaid = val;
                          if (val && _totalCtrl.text.isNotEmpty) {
                            _paidCtrl.text = _totalCtrl.text;
                          }
                        });
                      },
                      activeThumbColor: AppColors.success,
                      activeTrackColor:
                          AppColors.success.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                text: _isEditing ? 'Update Fee' : 'Save Fee',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
