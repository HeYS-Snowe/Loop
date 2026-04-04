extension DateExtensions on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool get isToday {
    return isSameDay(DateTime.now());
  }

  bool get isYesterday {
    return isSameDay(DateTime.now().subtract(const Duration(days: 1)));
  }

  bool get isTomorrow {
    return isSameDay(DateTime.now().add(const Duration(days: 1)));
  }

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  DateTime get startOfMonth => DateTime(year, month);

  DateTime get endOfMonth => DateTime(year, month + 1, 0);

  DateTime get startOfYear => DateTime(year);

  DateTime get endOfYear => DateTime(year, 12, 31);

  String format({String pattern = 'yyyy-MM-dd'}) {
    final year = this.year.toString();
    final month = this.month.toString().padLeft(2, '0');
    final day = this.day.toString().padLeft(2, '0');
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');

    return pattern
        .replaceAll('yyyy', year)
        .replaceAll('MM', month)
        .replaceAll('dd', day)
        .replaceAll('HH', hour)
        .replaceAll('mm', minute);
  }

  String formatCN() => '$year年$month月$day日';

  int daysUntil(DateTime other) => other.difference(this).inDays;

  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start.subtract(const Duration(microseconds: 1))) &&
        isBefore(end.add(const Duration(microseconds: 1)));
  }
}
