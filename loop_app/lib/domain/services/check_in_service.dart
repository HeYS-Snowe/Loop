import '../../data/repositories/check_in_repository.dart';
import '../../data/database/app_database.dart';

class CheckInService {
  final CheckInRepository _repository;

  CheckInService(this._repository);

  Future<bool> hasCheckedInToday() {
    return _repository.hasCheckedInToday();
  }

  Future<CheckInRecord> checkIn({String? note}) {
    return _repository.checkIn(note: note);
  }

  Future<int> getCurrentStreak() {
    return _repository.getCurrentStreak();
  }

  Future<List<CheckInRecord>> getAllCheckIns() {
    return _repository.getAllCheckIns();
  }

  Stream<List<CheckInRecord>> watchAllCheckIns() {
    return _repository.watchAllCheckIns();
  }

  Future<CheckInStats> getCheckInStats() async {
    final checkIns = await _repository.getAllCheckIns();
    final currentStreak = await _repository.getCurrentStreak();

    int maxStreak = 0;

    if (checkIns.isNotEmpty) {
      checkIns.sort((a, b) => b.date.compareTo(a.date));
      maxStreak = checkIns.first.streakCount;
    }

    return CheckInStats(
      totalCheckIns: checkIns.length,
      currentStreak: currentStreak,
      maxStreak: maxStreak,
      totalDays: checkIns.length,
      checkedInDates: checkIns.map((r) => r.date).toList(),
    );
  }
}

class CheckInStats {
  final int totalCheckIns;
  final int currentStreak;
  final int maxStreak;
  final int totalDays;
  final List<DateTime> checkedInDates;

  CheckInStats({
    required this.totalCheckIns,
    required this.currentStreak,
    required this.maxStreak,
    this.totalDays = 0,
    this.checkedInDates = const [],
  });
}
