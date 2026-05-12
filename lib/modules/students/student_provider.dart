import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'student_model.dart';

class StudentNotifier extends StateNotifier<List<StudentModel>> {
  StudentNotifier()
      : super([
          StudentModel(
            id: '1',
            name: 'Rahul Sharma',
            batch: 'Class 12 - Science',
            phone: '+91 9876543210',
          ),
          StudentModel(
            id: '2',
            name: 'Priya Singh',
            batch: 'NEET Batch',
            phone: '+91 9876543211',
          ),
          StudentModel(
            id: '3',
            name: 'Aman Verma',
            batch: 'JEE Advanced',
            phone: '+91 9876543212',
          ),
        ]);

  void addStudent(StudentModel student) {
    state = [...state, student];
  }

  void removeStudent(String id) {
    state = state.where((s) => s.id != id).toList();
  }

  void updateStudent(StudentModel updated) {
    state = state.map((s) => s.id == updated.id ? updated : s).toList();
  }
}

final studentProvider =
    StateNotifierProvider<StudentNotifier, List<StudentModel>>(
  (ref) => StudentNotifier(),
);
