import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final notifier = SettingsNotifier();
  ref.onDispose(() {});
  SharedPreferences.getInstance().then((prefs) {
    notifier.loadSettings(prefs);
  });
  return notifier;
});

class SettingsState {
  final bool darkMode;
  final bool notificationsEnabled;
  final String defaultView;
  final int reminderMinutesBefore;

  SettingsState({
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.defaultView = 'home',
    this.reminderMinutesBefore = 15,
  });

  SettingsState copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
    String? defaultView,
    int? reminderMinutesBefore,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      defaultView: defaultView ?? this.defaultView,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState());

  Future<void> loadSettings(SharedPreferences prefs) async {
    state = SettingsState(
      darkMode: prefs.getBool('darkMode') ?? false,
      notificationsEnabled: prefs.getBool('notificationsEnabled') ?? true,
      defaultView: prefs.getString('defaultView') ?? 'home',
      reminderMinutesBefore: prefs.getInt('reminderMinutesBefore') ?? 15,
    );
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    state = state.copyWith(darkMode: value);
  }

  Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    state = state.copyWith(notificationsEnabled: value);
  }

  Future<void> setDefaultView(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultView', value);
    state = state.copyWith(defaultView: value);
  }

  Future<void> setReminderMinutesBefore(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminderMinutesBefore', value);
    state = state.copyWith(reminderMinutesBefore: value);
  }
}
