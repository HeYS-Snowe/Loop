import '../database/app_database.dart';

extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String get formattedDate {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  String get formattedTime {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String get formattedDateTime {
    return '$formattedDate $formattedTime';
  }
}

extension CycleExtension on Cycle {
  int get totalDays {
    return endDate.difference(startDate).inDays + 1;
  }

  int get remainingDays {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    if (now.isBefore(startDate)) return totalDays;
    return endDate.difference(now).inDays + 1;
  }

  int get elapsedDays {
    final now = DateTime.now();
    if (now.isBefore(startDate)) return 0;
    if (now.isAfter(endDate)) return totalDays;
    return now.difference(startDate).inDays + 1;
  }

  double get progress {
    return (elapsedDays / totalDays).clamp(0.0, 1.0);
  }

  bool get isExpired {
    return DateTime.now().isAfter(endDate);
  }

  bool get isNotStarted {
    return DateTime.now().isBefore(startDate);
  }

  bool get isOngoing {
    final now = DateTime.now();
    return !now.isBefore(startDate) && !now.isAfter(endDate);
  }
}

extension TaskExtension on Task {
  double get progress {
    if (targetAmount <= 0) return 0;
    return (completedAmount / targetAmount).clamp(0.0, 1.0);
  }

  int get remainingAmount {
    return (targetAmount - completedAmount).clamp(0, targetAmount);
  }

  bool get isFullyCompleted {
    return completedAmount >= targetAmount && targetAmount > 0;
  }
}

extension CheckInRecordExtension on CheckInRecord {
  bool get isToday {
    return date.isToday;
  }

  bool get isYesterday {
    return date.isYesterday;
  }
}
