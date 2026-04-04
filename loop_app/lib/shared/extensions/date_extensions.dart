import 'package:flutter/material.dart';

extension DateExtensions on DateTime {
  String get formattedDate {
    return '$year年$month月$day日';
  }

  String get formattedTime {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String get formattedDateTime {
    return '$formattedDate $formattedTime';
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool get isToday {
    final now = DateTime.now();
    return isSameDay(now);
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(tomorrow);
  }

  String get weekdayName {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weekdays[weekday - 1];
  }

  String get relativeDay {
    if (isToday) return '今天';
    if (isYesterday) return '昨天';
    if (isTomorrow) return '明天';
    return formattedDate;
  }

  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59);
  }

  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }

  DateTime get endOfMonth {
    return DateTime(year, month + 1, 0);
  }

  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1));
  }

  DateTime get endOfWeek {
    return add(Duration(days: 7 - weekday));
  }
}
