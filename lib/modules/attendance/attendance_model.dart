class AttendanceModel {
  final String studentId;
  final String studentName;
  final DateTime date;
  final bool isPresent;

  const AttendanceModel({
    required this.studentId,
    required this.studentName,
    required this.date,
    required this.isPresent,
  });

  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  AttendanceModel copyWith({
    String? studentId,
    String? studentName,
    DateTime? date,
    bool? isPresent,
  }) {
    return AttendanceModel(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      date: date ?? this.date,
      isPresent: isPresent ?? this.isPresent,
    );
  }
}
