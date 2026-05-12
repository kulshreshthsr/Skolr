import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'attendance_model.dart';
import '../students/student_model.dart';

class AttendanceNotifier extends StateNotifier<List<AttendanceModel>> {
  AttendanceNotifier() : super([]);

  // Seeds all-absent records for the given day if not already present.
  void initializeDay(List<StudentModel> students, DateTime date) {
    final key = _key(date);
    if (state.any((r) => r.dateKey == key)) return;

    state = [
      ...state,
      ...students.map(
        (s) => AttendanceModel(
          studentId: s.id,
          studentName: s.name,
          date: date,
          isPresent: false,
        ),
      ),
    ];
  }

  void toggleAttendance(String studentId, DateTime date) {
    final key = _key(date);
    state = state.map((r) {
      if (r.studentId == studentId && r.dateKey == key) {
        return r.copyWith(isPresent: !r.isPresent);
      }
      return r;
    }).toList();
  }

  // Mark all present for a given day.
  void markAllPresent(DateTime date) {
    final key = _key(date);
    state = state
        .map((r) => r.dateKey == key ? r.copyWith(isPresent: true) : r)
        .toList();
  }

  // Mark all absent for a given day.
  void markAllAbsent(DateTime date) {
    final key = _key(date);
    state = state
        .map((r) => r.dateKey == key ? r.copyWith(isPresent: false) : r)
        .toList();
  }

  String _key(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, List<AttendanceModel>>(
  (ref) => AttendanceNotifier(),
);
