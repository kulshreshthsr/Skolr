import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fee_model.dart';

class FeeNotifier extends StateNotifier<List<FeeModel>> {
  FeeNotifier()
      : super([
          FeeModel(
            id: 'f1',
            studentId: '1',
            studentName: 'Rahul Sharma',
            totalAmount: 15000,
            paidAmount: 15000,
            dueDate: DateTime(2026, 4, 30),
            isPaid: true,
          ),
          FeeModel(
            id: 'f2',
            studentId: '2',
            studentName: 'Priya Singh',
            totalAmount: 12000,
            paidAmount: 8000,
            dueDate: DateTime(2026, 5, 15),
            isPaid: false,
          ),
          FeeModel(
            id: 'f3',
            studentId: '3',
            studentName: 'Aman Verma',
            totalAmount: 18000,
            paidAmount: 0,
            dueDate: DateTime(2026, 5, 10),
            isPaid: false,
          ),
        ]);

  void addFee(FeeModel fee) {
    state = [...state, fee];
  }

  void updateFee(FeeModel updated) {
    state = state.map((f) => f.id == updated.id ? updated : f).toList();
  }

  void removeFee(String id) {
    state = state.where((f) => f.id != id).toList();
  }

  void markPaid(String id) {
    state = state.map((f) {
      if (f.id == id) return f.copyWith(isPaid: true, paidAmount: f.totalAmount);
      return f;
    }).toList();
  }
}

final feeProvider = StateNotifierProvider<FeeNotifier, List<FeeModel>>(
  (ref) => FeeNotifier(),
);
