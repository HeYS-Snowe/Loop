class AppDateUtils {
  AppDateUtils._();

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static int daysBetween(DateTime from, DateTime to) {
    final fromDay = startOfDay(from);
    final toDay = startOfDay(to);
    return toDay.difference(fromDay).inDays;
  }

  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return format
        .replaceAll('yyyy', year)
        .replaceAll('MM', month)
        .replaceAll('dd', day);
  }
}
