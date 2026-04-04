import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/check_in_repository.dart';
import 'cycle_provider.dart';

final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  return CheckInRepository(ref.watch(databaseProvider));
});

final checkInNotifierProvider =
    StateNotifierProvider<CheckInNotifier, AsyncValue<CheckInState>>((ref) {
  return CheckInNotifier(ref.watch(checkInRepositoryProvider));
});

final checkInRecordsProvider = FutureProvider<List<CheckInRecord>>((ref) async {
  final repository = ref.watch(checkInRepositoryProvider);
  return repository.getAllRecords();
});

class CheckInState {
  final bool checkedIn;
  final int streakCount;
  final int maxStreak;
  final int totalCheckIns;

  CheckInState({
    required this.checkedIn,
    required this.streakCount,
    required this.maxStreak,
    required this.totalCheckIns,
  });
}

class CheckInNotifier extends StateNotifier<AsyncValue<CheckInState>> {
  final CheckInRepository _repository;

  CheckInNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadState();
  }

  Future<void> loadState() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final today = DateTime.now();
      final todayRecord = await _repository.getRecordByDate(today);
      final allRecords = await _repository.getAllRecords();

      final streakCount = _calculateStreak(allRecords, today);
      final maxStreak = _calculateMaxStreak(allRecords);

      return CheckInState(
        checkedIn: todayRecord != null,
        streakCount: streakCount,
        maxStreak: maxStreak,
        totalCheckIns: allRecords.length,
      );
    });
  }

  Future<void> checkIn() async {
    final currentState = state.value;
    if (currentState == null || currentState.checkedIn) return;

    state = await AsyncValue.guard(() async {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      final yesterdayRecord = await _repository.getRecordByDate(yesterday);

      int newStreak = 1;
      if (yesterdayRecord != null) {
        newStreak = currentState.streakCount + 1;
      }

      await _repository.insertRecord(CheckInRecordsCompanion(
        id: Value(Uuid().v4()),
        date: Value(today),
        streakCount: Value(newStreak),
        createdAt: Value(today),
      ));

      final allRecords = await _repository.getAllRecords();
      final maxStreak = _calculateMaxStreak(allRecords);

      return CheckInState(
        checkedIn: true,
        streakCount: newStreak,
        maxStreak: maxStreak,
        totalCheckIns: allRecords.length,
      );
    });
  }

  int _calculateStreak(List<CheckInRecord> records, DateTime today) {
    if (records.isEmpty) return 0;

    final sortedRecords = records..sort((a, b) => b.date.compareTo(a.date));
    final yesterday = today.subtract(const Duration(days: 1));

    final hasTodayOrYesterday = sortedRecords.any((r) =>
        _isSameDay(r.date, today) || _isSameDay(r.date, yesterday));

    if (!hasTodayOrYesterday) return 0;

    int streak = 1;
    for (int i = 1; i < sortedRecords.length; i++) {
      final diff = sortedRecords[i - 1].date.difference(sortedRecords[i].date).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  int _calculateMaxStreak(List<CheckInRecord> records) {
    if (records.isEmpty) return 0;

    final sortedRecords = records..sort((a, b) => a.date.compareTo(b.date));
    int maxStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < sortedRecords.length; i++) {
      final diff = sortedRecords[i].date.difference(sortedRecords[i - 1].date).inDays;
      if (diff == 1) {
        currentStreak++;
        maxStreak = maxStreak > currentStreak ? maxStreak : currentStreak;
      } else {
        currentStreak = 1;
      }
    }

    return maxStreak;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class Uuid {
  String v4() {
    final random = DateTime.now().microsecondsSinceEpoch;
    return '${random.toRadixString(16).padLeft(8, '0')}-'
        '${(random ^ 0xFFFF).toRadixString(16).padLeft(4, '0')}-'
        '4${(random & 0x0FFF).toRadixString(16).padLeft(3, '0')}-'
        '${(random & 0x3FFF | 0x8000).toRadixString(16).padLeft(4, '0')}-'
        '${(random ^ 0xFFFFFFFF).toRadixString(16).padLeft(8, '0')}'
        '${random.toRadixString(16).padLeft(4, '0')}';
  }
}
