import '../database/app_database.dart';

extension CycleExtension on Cycle {
  bool get isActive => status == 'active';

  bool get isCompleted => status == 'completed';

  int get remainingDays {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.differenceInDays(now);
  }

  int get totalDays => endDate.differenceInDays(startDate) + 1;

  int get elapsedDays {
    final now = DateTime.now();
    if (now.isBefore(startDate)) return 0;
    if (now.isAfter(endDate)) return totalDays;
    return now.differenceInDays(startDate) + 1;
  }

  double get progressPercentage {
    return (elapsedDays / totalDays).clamp(0.0, 1.0);
  }
}

extension TaskExtension on Task {
  double get progress {
    if (targetAmount <= 0) return 0;
    return (completedAmount / targetAmount).clamp(0.0, 1.0);
  }
}

extension DateTimeExtension on DateTime{
  int differenceInDays(DateTime other) {
    return difference(other).inDays;
  }
}
