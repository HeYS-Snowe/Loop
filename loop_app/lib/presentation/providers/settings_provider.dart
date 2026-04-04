import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

class SettingsState {
  final bool enableNotifications;
  final TimeOfDay notificationTime;
  final int defaultCycleDays;
  final bool autoExtendCycle;

  SettingsState({
    this.enableNotifications = true,
    this.notificationTime = const TimeOfDay(hour: 20, minute: 0),
    this.defaultCycleDays = 30,
    this.autoExtendCycle = false,
  });

  SettingsState copyWith({
    bool? enableNotifications,
    TimeOfDay? notificationTime,
    int? defaultCycleDays,
    bool? autoExtendCycle,
  }) {
    return SettingsState(
      enableNotifications: enableNotifications ?? this.enableNotifications,
      notificationTime: notificationTime ?? this.notificationTime,
      defaultCycleDays: defaultCycleDays ?? this.defaultCycleDays,
      autoExtendCycle: autoExtendCycle ?? this.autoExtendCycle,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState());

  Future<void> loadSettings(SharedPreferences prefs) async {
    final hour = prefs.getInt('reminder_hour') ?? 20;
    final minute = prefs.getInt('reminder_minute') ?? 0;
    state = SettingsState(
      enableNotifications: prefs.getBool('notifications_enabled') ?? true,
      notificationTime: TimeOfDay(hour: hour, minute: minute),
      defaultCycleDays: prefs.getInt('default_cycle_days') ?? 30,
      autoExtendCycle: prefs.getBool('auto_extend_cycle') ?? false,
    );
  }

  Future<void> updateNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    state = state.copyWith(enableNotifications: enabled);
  }

  Future<void> updateReminderTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminder_hour', time.hour);
    await prefs.setInt('reminder_minute', time.minute);
    state = state.copyWith(notificationTime: time);
  }

  Future<void> updateDefaultCycleDays(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('default_cycle_days', days);
    state = state.copyWith(defaultCycleDays: days);
  }

  Future<void> updateAutoExtend(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_extend_cycle', enabled);
    state = state.copyWith(autoExtendCycle: enabled);
  }
}
