import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'institute_model.dart';

class InstituteState {
  final bool isLoading;
  final InstituteModel? institute;

  const InstituteState({this.isLoading = true, this.institute});
}

class InstituteNotifier extends StateNotifier<InstituteState> {
  InstituteNotifier() : super(const InstituteState());

  static const _key = 'institute_data';

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);

    if (jsonStr != null) {
      try {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        state = InstituteState(
          isLoading: false,
          institute: InstituteModel.fromMap(map),
        );
        return;
      } catch (_) {
        // corrupted data — fall through to no-data state
      }
    }

    state = const InstituteState(isLoading: false);
  }

  Future<void> save(InstituteModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(model.toMap()));
    state = InstituteState(isLoading: false, institute: model);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    state = const InstituteState(isLoading: false);
  }
}

final instituteProvider =
    StateNotifierProvider<InstituteNotifier, InstituteState>(
  (ref) => InstituteNotifier(),
);
