class FeeModel {
  final String id;
  final String studentId;
  final String studentName;
  final double totalAmount;
  final double paidAmount;
  final DateTime dueDate;
  final bool isPaid;

  FeeModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueDate,
    required this.isPaid,
  });

  double get dueAmount =>
      (totalAmount - paidAmount).clamp(0.0, double.infinity);

  FeeModel copyWith({
    String? id,
    String? studentId,
    String? studentName,
    double? totalAmount,
    double? paidAmount,
    DateTime? dueDate,
    bool? isPaid,
  }) {
    return FeeModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      dueDate: dueDate ?? this.dueDate,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
