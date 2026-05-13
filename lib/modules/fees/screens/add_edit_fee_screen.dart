import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/skolr_card.dart';
import '../../../core/widgets/skolr_text_field.dart';
import '../../students/student_provider.dart';
import '../fee_model.dart';
import '../fee_provider.dart';

// ---------------------------------------------------------------------------
// AddEditFeeScreen — create or edit a fee record.
//
// Visual recipe:
//   • Page gradient background
//   • Headline + subhead
//   • Glass form card with:
//     - Custom student picker (dropdown in glass surface)
//     - Total / Paid amount fields with currency prefix
//     - Custom date picker tile (styled to match v2)
//     - Premium "Mark Paid" toggle row
//   • Gradient submit CTA
// ---------------------------------------------------------------------------

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

  String? _studentError;
  String? _totalError;
  String? _paidError;

  bool get _isEditing => widget.existingFee != null;

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
      builder: (context, child) {
        // Use Skolr's theme colors in the date picker.
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: SkolrColors.primary,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _save() {
    setState(() {
      _studentError =
          _selectedStudentId == null ? 'Please select a student' : null;
      _totalError = null;
      _paidError = null;
    });

    if (_studentError != null) return;

    final total = double.tryParse(_totalCtrl.text.trim()) ?? 0;
    final paid = double.tryParse(_paidCtrl.text.trim()) ?? 0;

    if (total <= 0) {
      setState(() => _totalError = 'Total must be greater than 0');
      return;
    }
    if (paid > total) {
      setState(() => _paidError = 'Paid amount cannot exceed total');
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

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final cs = Theme.of(context).colorScheme;
    final students = ref.watch(studentProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Fee Record' : 'Add Fee Record'),
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
                  _isEditing ? 'Edit Fee Record' : 'New Fee Record',
                  style: SkolrTypography.headlineLarge(color: cs.onSurface),
                ),
                const SkolrGap.xs(),
                Text(
                  'Fill in the fee details below',
                  style: SkolrTypography.bodyLarge(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SkolrGap.xxl(),

                // ── Form card ────────────────────────────────────
                SkolrCard(
                  padding: const EdgeInsets.all(SkolrSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Student picker
                      _FieldLabel('Student', required: true),
                      const SkolrGap.sm(),
                      _StudentPicker(
                        students: students,
                        selectedId: _selectedStudentId,
                        error: _studentError,
                        onChanged: (value) {
                          if (value == null) return;
                          final s =
                              students.firstWhere((s) => s.id == value);
                          setState(() {
                            _selectedStudentId = value;
                            _selectedStudentName = s.name;
                            _studentError = null;
                          });
                        },
                      ),
                      if (students.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: SkolrSpacing.sm,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 14,
                                color: SkolrColors.warning,
                              ),
                              const SkolrGap.xs(),
                              Expanded(
                                child: Text(
                                  'No students yet. Add students first.',
                                  style: SkolrTypography.labelMedium(
                                    color: SkolrColors.warning,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SkolrGap.lg(),

                      _FieldLabel('Total Amount', required: true),
                      const SkolrGap.sm(),
                      SkolrTextField(
                        controller: _totalCtrl,
                        hint: 'e.g. 15000',
                        error: _totalError,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: SkolrSpacing.md),
                          child: Icon(Icons.currency_rupee_rounded),
                        ),
                        textInputAction: TextInputAction.next,
                        onChanged: (_) {
                          if (_totalError != null) {
                            setState(() => _totalError = null);
                          }
                        },
                      ),
                      const SkolrGap.lg(),

                      _FieldLabel('Paid Amount'),
                      const SkolrGap.sm(),
                      SkolrTextField(
                        controller: _paidCtrl,
                        hint: 'e.g. 5000',
                        error: _paidError,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: SkolrSpacing.md),
                          child: Icon(Icons.currency_rupee_rounded),
                        ),
                        textInputAction: TextInputAction.done,
                        onChanged: (_) {
                          if (_paidError != null) {
                            setState(() => _paidError = null);
                          }
                        },
                      ),
                      const SkolrGap.lg(),

                      // Due date picker tile
                      _FieldLabel('Due Date'),
                      const SkolrGap.sm(),
                      _DatePickerTile(
                        date: _dueDate,
                        formatted: _formatDate(_dueDate),
                        onTap: _pickDate,
                      ),
                      const SkolrGap.lg(),

                      // Mark Paid toggle
                      _PaidToggle(
                        value: _isPaid,
                        onChanged: (val) {
                          setState(() {
                            _isPaid = val;
                            if (val && _totalCtrl.text.isNotEmpty) {
                              _paidCtrl.text = _totalCtrl.text;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SkolrGap.xxl(),

                PrimaryButton(
                  text: _isEditing ? 'Update Fee' : 'Save Fee',
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

// ─── Field label ────────────────────────────────────────────────────────────

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

// ─── Custom student picker (glass dropdown) ─────────────────────────────────

class _StudentPicker extends StatelessWidget {
  const _StudentPicker({
    required this.students,
    required this.selectedId,
    required this.onChanged,
    this.error,
  });

  final List students;
  final String? selectedId;
  final ValueChanged<String?> onChanged;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = error != null;

    final valid = students.any((s) => s.id == selectedId) ? selectedId : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: SkolrSpacing.md),
          decoration: BoxDecoration(
            color: isDark
                ? SkolrColors.midnight700.withValues(alpha: 0.6)
                : SkolrColors.lightSurfaceAlt,
            borderRadius: SkolrRadius.md,
            border: Border.all(
              color: hasError
                  ? cs.error
                  : (isDark
                      ? SkolrColors.glassBorder
                      : SkolrColors.lightBorder),
              width: hasError ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 20,
                color: cs.onSurfaceVariant,
              ),
              const SkolrGap.md(),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: valid,
                    isExpanded: true,
                    icon: Icon(
                      Icons.expand_more_rounded,
                      color: cs.onSurfaceVariant,
                    ),
                    hint: Text(
                      'Select student',
                      style: SkolrTypography.bodyLarge(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    style: SkolrTypography.bodyLarge(color: cs.onSurface),
                    dropdownColor: isDark
                        ? SkolrColors.midnight600
                        : SkolrColors.lightSurface,
                    borderRadius: SkolrRadius.md,
                    items: students
                        .map<DropdownMenuItem<String>>(
                          (s) => DropdownMenuItem(
                            value: s.id as String,
                            child: Text(
                              '${s.name} — ${s.batch}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: students.isEmpty ? null : onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(
              top: SkolrSpacing.xs,
              left: SkolrSpacing.lg,
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded, size: 12, color: cs.error),
                const SkolrGap.xs(),
                Text(
                  error!,
                  style: SkolrTypography.labelMedium(color: cs.error),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ─── Custom date picker tile ────────────────────────────────────────────────

class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({
    required this.date,
    required this.formatted,
    required this.onTap,
  });

  final DateTime date;
  final String formatted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: SkolrRadius.md,
        child: Ink(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: SkolrSpacing.md),
          decoration: BoxDecoration(
            color: isDark
                ? SkolrColors.midnight700.withValues(alpha: 0.6)
                : SkolrColors.lightSurfaceAlt,
            borderRadius: SkolrRadius.md,
            border: Border.all(
              color: isDark
                  ? SkolrColors.glassBorder
                  : SkolrColors.lightBorder,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: SkolrColors.primary,
                size: 20,
              ),
              const SkolrGap.md(),
              Expanded(
                child: Text(
                  formatted,
                  style: SkolrTypography.bodyLarge(color: cs.onSurface),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Premium toggle row ─────────────────────────────────────────────────────

class _PaidToggle extends StatelessWidget {
  const _PaidToggle({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: SkolrMotion.fast,
      padding: const EdgeInsets.symmetric(
        horizontal: SkolrSpacing.md,
        vertical: SkolrSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: value
            ? LinearGradient(
                colors: [
                  SkolrColors.success
                      .withValues(alpha: isDark ? 0.15 : 0.10),
                  SkolrColors.success
                      .withValues(alpha: isDark ? 0.05 : 0.03),
                ],
              )
            : null,
        color: value
            ? null
            : (isDark
                ? SkolrColors.midnight700.withValues(alpha: 0.6)
                : SkolrColors.lightSurfaceAlt),
        borderRadius: SkolrRadius.md,
        border: Border.all(
          color: value
              ? SkolrColors.success.withValues(alpha: 0.4)
              : (isDark ? SkolrColors.glassBorder : SkolrColors.lightBorder),
        ),
      ),
      child: Row(
        children: [
          Icon(
            value
                ? Icons.check_circle_rounded
                : Icons.check_circle_outline_rounded,
            color: value ? SkolrColors.success : cs.onSurfaceVariant,
            size: 20,
          ),
          const SkolrGap.md(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mark as Fully Paid',
                  style: SkolrTypography.titleSmall(color: cs.onSurface),
                ),
                Text(
                  value ? 'Paid amount set to total' : 'Tap to mark as paid',
                  style: SkolrTypography.bodySmall(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: SkolrColors.success,
          ),
        ],
      ),
    );
  }
}