import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../domain/services/check_in_service.dart';
import 'cycle_provider.dart';

final checkInServiceProvider = Provider<CheckInService>((ref) {
  return CheckInService(ref.watch(checkInRepositoryProvider));
});

final checkInsProvider = FutureProvider<List<CheckInRecord>>((ref) async {
  final service = ref.watch(checkInServiceProvider);
  return service.getAllCheckIns();
});

final hasCheckedInTodayProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(checkInServiceProvider);
  return service.hasCheckedInToday();
});

final currentStreakProvider = FutureProvider<int>((ref) async {
  final service = ref.watch(checkInServiceProvider);
  return service.getCurrentStreak();
});

final checkInStatsProvider = FutureProvider<CheckInStats>((ref) async {
  final service = ref.watch(checkInServiceProvider);
  return service.getCheckInStats();
});

class CheckInState {
  final bool checkedInToday;
  final int streakCount;
  final List<CheckInRecord> records;

  CheckInState({
    this.checkedInToday = false,
    this.streakCount = 0,
    this.records = const [],
  });

  CheckInState copyWith({
    bool? checkedInToday,
    int? streakCount,
    List<CheckInRecord>? records,
  }) {
    return CheckInState(
      checkedInToday: checkedInToday ?? this.checkedInToday,
      streakCount: streakCount ?? this.streakCount,
      records: records ?? this.records,
    );
  }
}

class CheckInNotifier extends AsyncNotifier<CheckInState> {
  @override
  CheckInState build() {
    return CheckInState();
  }

  CheckInService get _service => ref.read(checkInServiceProvider);

  Future<void> checkIn() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _service.checkIn();
      final checkedInToday = await _service.hasCheckedInToday();
      final streakCount = await _service.getCurrentStreak();
      final records = await _service.getAllCheckIns();
      return CheckInState(
        checkedInToday: checkedInToday,
        streakCount: streakCount,
        records: records,
      );
    });
  }

  Future<void> loadState() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final checkedInToday = await _service.hasCheckedInToday();
      final streakCount = await _service.getCurrentStreak();
      final records = await _service.getAllCheckIns();
      return CheckInState(
        checkedInToday: checkedInToday,
        streakCount: streakCount,
        records: records,
      );
    });
  }
}

final checkInNotifierProvider =
    AsyncNotifierProvider<CheckInNotifier, CheckInState>(
  CheckInNotifier.new,
);
