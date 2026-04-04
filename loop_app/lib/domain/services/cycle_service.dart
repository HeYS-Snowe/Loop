import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../data/repositories/task_repository.dart';

class CycleService {
  final CycleRepository _cycleRepository;
  final TaskRepository _taskRepository;

  CycleService(this._cycleRepository, this._taskRepository);

  Future<Cycle?> getActiveCycle() async {
    return await _cycleRepository.getActiveCycle();
  }

  Future<List<Cycle>> getAllCycles() async {
    return await _cycleRepository.getAllCycles();
  }

  Future<void> createCycle(CyclesCompanion cycle) async {
    final activeCycle = await _cycleRepository.getActiveCycle();
    if (activeCycle != null) {
      await _cycleRepository.updateCycle(CyclesCompanion(
        id: Value(activeCycle.id),
        isActive: const Value(false),
        updatedAt: Value(DateTime.now()),
      ));
    }

    await _cycleRepository.insertCycle(cycle);
  }

  Future<void> activateCycle(String cycleId) async {
    final activeCycle = await _cycleRepository.getActiveCycle();
    if (activeCycle != null) {
      await _cycleRepository.updateCycle(CyclesCompanion(
        id: Value(activeCycle.id),
        isActive: const Value(false),
        updatedAt: Value(DateTime.now()),
      ));
    }

    await _cycleRepository.updateCycle(CyclesCompanion(
      id: Value(cycleId),
      isActive: const Value(true),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> endCycle(String cycleId) async {
    await _cycleRepository.updateCycle(CyclesCompanion(
      id: Value(cycleId),
      isActive: const Value(false),
      endDate: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<double> getCycleProgress(String cycleId) async {
    final cycle = await _cycleRepository.getCycleById(cycleId);
    if (cycle == null) return 0;

    final tasks = await _taskRepository.getTasksByCycle(cycleId);
    if (tasks.isEmpty) return 0;

    final completedTasks = tasks.where((t) => t.isCompleted).length;
    return completedTasks / tasks.length;
  }

  Future<Map<String, dynamic>> getCycleStatistics(String cycleId) async {
    final cycle = await _cycleRepository.getCycleById(cycleId);
    if (cycle == null) {
      return {
        'totalTasks': 0,
        'completedTasks': 0,
        'totalProgress': 0.0,
        'daysElapsed': 0,
        'daysRemaining': 0,
      };
    }

    final tasks = await _taskRepository.getTasksByCycle(cycleId);
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final now = DateTime.now();

    int daysElapsed = 0;
    int daysRemaining = 0;

    if (now.isAfter(cycle.startDate)) {
      daysElapsed = now.difference(cycle.startDate).inDays + 1;
    }

    if (now.isBefore(cycle.endDate)) {
      daysRemaining = cycle.endDate.difference(now).inDays + 1;
    }

    return {
      'totalTasks': tasks.length,
      'completedTasks': completedTasks,
      'totalProgress': tasks.isEmpty ? 0.0 : completedTasks / tasks.length,
      'daysElapsed': daysElapsed,
      'daysRemaining': daysRemaining,
    };
  }
}
