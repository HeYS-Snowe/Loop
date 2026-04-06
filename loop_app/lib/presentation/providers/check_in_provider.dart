import 'package:flutter/foundation.dart';
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
  Future<CheckInState> build() async {
    return _loadFromService();
  }

  CheckInService get _service => ref.read(checkInServiceProvider);

  Future<CheckInState> _loadFromService() async {
    final checkedInToday = await _service.hasCheckedInToday();
    final streakCount = await _service.getCurrentStreak();
    final records = await _service.getAllCheckIns();
    return CheckInState(
      checkedInToday: checkedInToday,
      streakCount: streakCount,
      records: records,
    );
  }

  Future<void> checkIn() async {
    state = const AsyncValue.loading();
    try {
      await _service.checkIn();
      state = AsyncValue.data(await _loadFromService());
    } catch (e, st) {
      debugPrint('[CheckInNotifier.checkIn] ERROR: $e');
      debugPrint('[CheckInNotifier.checkIn] STACK: $st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadState() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await _loadFromService());
    } catch (e, st) {
      debugPrint('[CheckInNotifier.loadState] ERROR: $e');
      debugPrint('[CheckInNotifier.loadState] STACK: $st');
      state = AsyncValue.error(e, st);
    }
  }
}

final checkInNotifierProvider =
    AsyncNotifierProvider<CheckInNotifier, CheckInState>(
  CheckInNotifier.new,
);
