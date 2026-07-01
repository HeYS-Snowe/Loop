import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/services/notification_service.dart';

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

class SettingsState {
  final bool enableNotifications;
  final TimeOfDay notificationTime;
  final int defaultCycleDays;
  final bool autoExtendCycle;
  final Locale? locale;

  const SettingsState({
    this.enableNotifications = true,
    this.notificationTime = const TimeOfDay(hour: 20, minute: 0),
    this.defaultCycleDays = 30,
    this.autoExtendCycle = false,
    this.locale,
  });

  SettingsState copyWith({
    bool? enableNotifications,
    TimeOfDay? notificationTime,
    int? defaultCycleDays,
    bool? autoExtendCycle,
    Locale? locale,
  }) {
    return SettingsState(
      enableNotifications: enableNotifications ?? this.enableNotifications,
      notificationTime: notificationTime ?? this.notificationTime,
      defaultCycleDays: defaultCycleDays ?? this.defaultCycleDays,
      autoExtendCycle: autoExtendCycle ?? this.autoExtendCycle,
      locale: locale ?? this.locale,
    );
  }
}

class SettingsNotifier extends AsyncNotifier<SettingsState> {
  @override
  Future<SettingsState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('reminder_hour') ?? 20;
    final minute = prefs.getInt('reminder_minute') ?? 0;
    final localeCode = prefs.getString('locale');
    return SettingsState(
      enableNotifications: prefs.getBool('notifications_enabled') ?? true,
      notificationTime: TimeOfDay(hour: hour, minute: minute),
      defaultCycleDays: prefs.getInt('default_cycle_days') ?? 30,
      autoExtendCycle: prefs.getBool('auto_extend_cycle') ?? false,
      locale: localeCode != null ? Locale(localeCode) : null,
    );
  }

  Future<void> updateNotifications(bool enabled, {
    String? title,
    String? body,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    final current = state.value ?? const SettingsState();
    state = AsyncValue.data(current.copyWith(enableNotifications: enabled));

    final notificationService = NotificationService();
    if (enabled) {
      await notificationService.showDailyReminder(
        hour: current.notificationTime.hour,
        minute: current.notificationTime.minute,
        title: title ?? 'Loop',
        body: body ?? '',
      );
    } else {
      await notificationService.cancelAll();
    }
  }

  Future<void> updateReminderTime(TimeOfDay time, {
    String? title,
    String? body,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminder_hour', time.hour);
    await prefs.setInt('reminder_minute', time.minute);
    final current = state.value ?? const SettingsState();
    state = AsyncValue.data(current.copyWith(notificationTime: time));

    if (current.enableNotifications) {
      final notificationService = NotificationService();
      await notificationService.cancelAll();
      await notificationService.showDailyReminder(
        hour: time.hour,
        minute: time.minute,
        title: title ?? 'Loop',
        body: body ?? '',
      );
    }
  }

  Future<void> updateDefaultCycleDays(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('default_cycle_days', days);
    final current = state.value ?? const SettingsState();
    state = AsyncValue.data(current.copyWith(defaultCycleDays: days));
  }

  Future<void> updateAutoExtend(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_extend_cycle', enabled);
    final current = state.value ?? const SettingsState();
    state = AsyncValue.data(current.copyWith(autoExtendCycle: enabled));
  }

  Future<void> updateLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    final current = state.value ?? const SettingsState();
    state = AsyncValue.data(current.copyWith(locale: locale));
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
