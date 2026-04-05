import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

class TaskRepository {
  final AppDatabase _database;
  final _uuid = const Uuid();

  TaskRepository(this._database);

  Future<List<Task>> getTasksByCycle(String cycleId) =>
      _database.getTasksByCycle(cycleId);

  Stream<List<Task>> watchTasksByCycle(String cycleId) =>
      _database.watchTasksByCycle(cycleId);

  Future<Task?> getTaskById(String id) => _database.getTaskById(id);

  Future<Task> createTask({
    required String cycleId,
    required String name,
    String? description,
    required int targetAmount,
    String? unit,
    String? categoryId,
    bool isRepeatable = false,
    String? repeatType,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    await _database.insertTask(
      TasksCompanion(
        id: Value(id),
        cycleId: Value(cycleId),
        name: Value(name),
        description: Value(description),
        targetAmount: Value(targetAmount),
        completedAmount: const Value(0),
        unit: Value(unit),
        categoryId: Value(categoryId),
        isRepeatable: Value(isRepeatable),
        repeatType: Value(repeatType),
        isCompleted: const Value(false),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    return Task(
      id: id,
      cycleId: cycleId,
      name: name,
      description: description,
      targetAmount: targetAmount,
      completedAmount: 0,
      unit: unit,
      categoryId: categoryId,
      isRepeatable: isRepeatable,
      repeatType: repeatType,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<void> updateTask(Task task) async {
    await _database.updateTask(
      TasksCompanion(
        id: Value(task.id),
        cycleId: Value(task.cycleId),
        name: Value(task.name),
        description: Value(task.description),
        targetAmount: Value(task.targetAmount),
        completedAmount: Value(task.completedAmount),
        unit: Value(task.unit),
        categoryId: Value(task.categoryId),
        isRepeatable: Value(task.isRepeatable),
        repeatType: Value(task.repeatType),
        isCompleted: Value(task.isCompleted),
        createdAt: Value(task.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateProgress(String taskId, int amount) =>
      _database.updateTaskProgress(taskId, amount);

  Future<void> addProgress(String taskId, int additionalAmount) async {
    final task = await getTaskById(taskId);
    if (task != null) {
      final newAmount =
          (task.completedAmount + additionalAmount).clamp(0, task.targetAmount);
      await updateProgress(taskId, newAmount);

      if (newAmount >= task.targetAmount) {
        await _database.updateTask(
          TasksCompanion(
            id: Value(taskId),
            isCompleted: const Value(true),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
    }
  }

  Future<void> deleteTask(String id) => _database.deleteTask(id);
}
