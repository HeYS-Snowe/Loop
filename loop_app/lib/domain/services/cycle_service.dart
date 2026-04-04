import '../../data/repositories/cycle_repository.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/database/app_database.dart';
import '../../data/extensions/model_extensions.dart';

class CycleService {
  final CycleRepository _cycleRepository;
  final TaskRepository _taskRepository;

  CycleService(this._cycleRepository, this._taskRepository);

  Future<List<Cycle>> getAllCycles() {
    return _cycleRepository.getAllCycles();
  }

  Stream<List<Cycle>> watchAllCycles() {
    return _cycleRepository.watchAllCycles();
  }

  Future<Cycle?> getActiveCycle() {
    return _cycleRepository.getActiveCycle();
  }

  Future<Cycle?> getCycleById(String id) {
    return _cycleRepository.getCycleById(id);
  }

  Future<Cycle> createCycle({
    required String name,
    String? description,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _cycleRepository.createCycle(
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<void> updateCycle(Cycle cycle) {
    return _cycleRepository.updateCycle(cycle);
  }

  Future<void> completeCycle(String cycleId) async {
    await _cycleRepository.completeCycle(cycleId);
  }

  Future<void> deleteCycle(String id) async {
    final tasks = await _taskRepository.getTasksByCycle(id);
    for (final task in tasks) {
      await _taskRepository.deleteTask(task.id);
    }
    await _cycleRepository.deleteCycle(id);
  }

  Future<CycleWithTasks> getCycleWithTasks(String cycleId) async {
    final cycle = await _cycleRepository.getCycleById(cycleId);
    if (cycle == null) {
      throw Exception('Cycle not found');
    }
    final tasks = await _taskRepository.getTasksByCycle(cycleId);
    return CycleWithTasks(cycle: cycle, tasks: tasks);
  }
}

class CycleWithTasks {
  final Cycle cycle;
  final List<Task> tasks;

  CycleWithTasks({required this.cycle, required this.tasks});

  double get completionRate {
    if (tasks.isEmpty) return 0;
    final completed = tasks.where((t) => t.isCompleted).length;
    return completed / tasks.length;
  }

  int get totalProgress {
    if (tasks.isEmpty) return 0;
    final totalProgress = tasks.fold<double>(0, (sum, t) => sum + t.progress);
    return ((totalProgress / tasks.length) * 100).round();
  }
}
