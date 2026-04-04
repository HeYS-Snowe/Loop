import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/task_repository.dart';
import 'cycle_provider.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.watch(databaseProvider));
});

final taskDetailProvider = FutureProvider.family<Task?, String>((ref, taskId) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTaskById(taskId);
});

final tasksByCycleProvider = FutureProvider.family<List<Task>, String>((ref, cycleId) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTasksByCycle(cycleId);
});

final taskNotifierProvider = StateNotifierProvider<TaskNotifier, AsyncValue<void>>((ref) {
  return TaskNotifier(ref.watch(taskRepositoryProvider));
});

final tasksNotifierProvider = StateNotifierProvider.family<TasksNotifier, AsyncValue<List<Task>>, String>((ref, cycleId) {
  return TasksNotifier(ref.watch(taskRepositoryProvider), cycleId);
});

class TaskNotifier extends StateNotifier<AsyncValue<void>> {
  final TaskRepository _repository;

  TaskNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> createTask({
    required String cycleId,
    required String name,
    String? description,
    required int targetAmount,
    String? categoryId,
    String? unit,
    bool isRepeatable = false,
    String? repeatType,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.insertTask(TasksCompanion(
        id: Value(const Uuid().v4()),
        cycleId: Value(cycleId),
        name: Value(name),
        description: Value(description),
        targetAmount: Value(targetAmount),
        categoryId: Value(categoryId),
        unit: Value(unit),
        isRepeatable: Value(isRepeatable),
        repeatType: Value(repeatType),
        completedAmount: const Value(0),
        isCompleted: const Value(false),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ));
    });
  }

  Future<void> updateTask(TasksCompanion task) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateTask(task);
    });
  }

  Future<void> updateProgress(String taskId, int amount) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final task = await _repository.getTaskById(taskId);
      if (task == null) throw StateError('Task not found: $taskId');

      final clampedAmount = amount.clamp(0, task.targetAmount);
      final isCompleted = clampedAmount >= task.targetAmount && task.targetAmount > 0;

      await _repository.updateTask(TasksCompanion(
        id: Value(taskId),
        completedAmount: Value(clampedAmount),
        isCompleted: Value(isCompleted),
        updatedAt: Value(DateTime.now()),
      ));
    });
  }

  Future<void> deleteTask(String taskId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteTask(taskId);
    });
  }
}

class TasksNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskRepository _repository;
  final String cycleId;

  TasksNotifier(this._repository, this.cycleId) : super(const AsyncValue.loading()) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _repository.getTasksByCycle(cycleId);
    });
  }

  Future<void> loadTasks(String? newCycleId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _repository.getTasksByCycle(newCycleId ?? cycleId);
    });
  }

  Future<void> refresh() async {
    await _loadTasks();
  }
}
