import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/task_repository.dart';
import 'cycle_provider.dart';

final tasksByCycleProvider =
    FutureProvider.family<List<Task>, String>((ref, cycleId) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTasksByCycle(cycleId);
});

final taskDetailProvider =
    FutureProvider.family<Task?, String>((ref, taskId) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTaskById(taskId);
});

class TaskNotifier extends AsyncNotifier<List<Task>> {
  final String arg;

  TaskNotifier(this.arg);

  @override
  Future<List<Task>> build() async {
    final repository = ref.watch(taskRepositoryProvider);
    return repository.getTasksByCycle(arg);
  }

  TaskRepository get _repository => ref.read(taskRepositoryProvider);

  Future<void> createTask({
    required String name,
    String? description,
    required int targetAmount,
    String? categoryId,
    bool isRepeatable = false,
    String? unit,
  }) async {
    await _repository.createTask(
      cycleId: arg,
      name: name,
      description: description,
      targetAmount: targetAmount,
      categoryId: categoryId,
      isRepeatable: isRepeatable,
      unit: unit,
    );
    ref.invalidateSelf();
  }

  Future<void> updateProgress(String taskId, int additionalAmount) async {
    await _repository.addProgress(taskId, additionalAmount);
    ref.invalidateSelf();
  }

  Future<void> completeTask(String taskId) async {
    final task = await _repository.getTaskById(taskId);
    if (task != null) {
      await _repository.updateProgress(taskId, task.targetAmount);
    }
    ref.invalidateSelf();
  }

  Future<void> deleteTask(String taskId) async {
    await _repository.deleteTask(taskId);
    ref.invalidateSelf();
  }

  Future<void> editTask(Task task) async {
    await _repository.updateTask(task);
    ref.invalidateSelf();
  }
}

final taskNotifierProvider =
    AsyncNotifierProvider.family<TaskNotifier, List<Task>, String>(
  TaskNotifier.new,
);

/// 任务筛选模式: 0=全部, 1=进行中, 2=已完成
class TaskFilterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setFilter(int value) => state = value;
}

final taskFilterProvider =
    NotifierProvider<TaskFilterNotifier, int>(TaskFilterNotifier.new);
