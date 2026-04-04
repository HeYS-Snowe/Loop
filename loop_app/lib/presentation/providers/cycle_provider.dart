import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop/data/database/app_database.dart';
import 'package:loop/data/repositories/cycle_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final cycleRepositoryProvider = Provider<CycleRepository>((ref) {
  return CycleRepository(ref.watch(databaseProvider));
});

final allCyclesProvider = FutureProvider<List<Cycle>>((ref) {
  final repository = ref.watch(cycleRepositoryProvider);
  return repository.getAllCycles();
});

final activeCycleProvider = FutureProvider<Cycle?>((ref) async {
  final repository = ref.watch(cycleRepositoryProvider);
  return repository.getActiveCycle();
});

final cycleNotifierProvider =
    StateNotifierProvider<CycleNotifier, AsyncValue<List<Cycle>>>((ref) {
  return CycleNotifier(ref.watch(cycleRepositoryProvider));
});

class CycleNotifier extends StateNotifier<AsyncValue<List<Cycle>>> {
  final CycleRepository _repository;

  CycleNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadCycles() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getAllCycles());
  }

  Future<void> createCycle(CyclesCompanion cycle) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.insertCycle(cycle);
      return _repository.getAllCycles();
    });
  }

  Future<void> updateCycle(CyclesCompanion cycle) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateCycle(cycle);
      return _repository.getAllCycles();
    });
  }

  Future<void> deleteCycle(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteCycle(id);
      return _repository.getAllCycles();
    });
  }
}
