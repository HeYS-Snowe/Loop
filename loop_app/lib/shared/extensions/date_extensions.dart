import 'package:loop_app/l10n/generated/app_localizations.dart';

extension DateExtensions on DateTime {
  String format() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  String formatWithLocale(S s) {
    return s.dateYearMonthDay(year, month, day);
  }

  String get weekdayName {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
