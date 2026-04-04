import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/task_repository.dart';
import 'cycle_provider.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.watch(databaseProvider));
});

final tasksByCycleProvider =
    FutureProvider.family<List<Task>, String>((ref, cycleId) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTasksByCycle(cycleId);
});

final taskNotifierProvider =
    StateNotifierProvider.family<TaskNotifier, AsyncValue<List<Task>>, String>(
        (ref, cycleId) {
  return TaskNotifier(cycleId, ref.watch(taskRepositoryProvider));
});

final taskDetailProvider =
    FutureProvider.family<Task?, String>((ref, taskId) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTaskById(taskId);
});

class TaskNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final String _cycleId;
  final TaskRepository _repository;

  TaskNotifier(this._cycleId, this._repository)
      : super(const AsyncValue.loading());

  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _repository.getTasksByCycle(_cycleId);
    });
  }

  Future<void> createTask({
    required String name,
    String? description,
    required int targetAmount,
    String? categoryId,
    bool isRepeatable = false,
    String? unit,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.createTask(
        cycleId: _cycleId,
        name: name,
        description: description,
        targetAmount: targetAmount,
        categoryId: categoryId,
        isRepeatable: isRepeatable,
        unit: unit,
      );
      return _repository.getTasksByCycle(_cycleId);
    });
  }

  Future<void> updateProgress(String taskId, int additionalAmount) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.addProgress(taskId, additionalAmount);
      return _repository.getTasksByCycle(_cycleId);
    });
  }

  Future<void> completeTask(String taskId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final task = await _repository.getTaskById(taskId);
      if (task != null) {
        await _repository.updateProgress(taskId, task.targetAmount);
      }
      return _repository.getTasksByCycle(_cycleId);
    });
  }

  Future<void> deleteTask(String taskId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteTask(taskId);
      return _repository.getTasksByCycle(_cycleId);
    });
  }

  Future<void> editTask(Task task) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.editTask(task);
      return _repository.getTasksByCycle(_cycleId);
    });
  }
}
