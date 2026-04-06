import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open',
    );
    const settings = InitializationSettings(
      android: androidSettings,
      linux: linuxSettings,
    );
    await _plugin.initialize(settings: settings);
  }

  Future<void> showDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'daily_reminder',
      'Daily Reminder',
      channelDescription: 'Daily reminder for cycle tasks',
      importance: Importance.high,
      priority: Priority.high,
    );
    final details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id: 0,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
