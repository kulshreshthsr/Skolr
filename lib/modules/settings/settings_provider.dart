// Reserved for future app-level preferences (notifications, theme, etc.).
// Institute details (name, type, phone, address) are managed by InstituteProvider.
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsModel {
  const SettingsModel();
}

class SettingsNotifier extends StateNotifier<SettingsModel> {
  SettingsNotifier() : super(const SettingsModel());
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsModel>(
  (ref) => SettingsNotifier(),
);
