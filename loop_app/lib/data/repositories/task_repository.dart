import 'package:drift/drift.dart';
import '../database/app_database.dart';

class TaskRepository {
  final AppDatabase _database;

  TaskRepository(this._database);

  Future<List<Task>> getTasksByCycle(String cycleId) {
    return _database.getTasksByCycle(cycleId);
  }

  Stream<List<Task>> watchTasksByCycle(String cycleId) {
    return _database.watchTasksByCycle(cycleId);
  }

  Future<Task?> getTaskById(String id) {
    return _database.getTaskById(id);
  }

  Future<void> createTask({
    required String cycleId,
    required String name,
    String? description,
    required int targetAmount,
    String? categoryId,
    bool isRepeatable = false,
    String? unit,
  }) async {
    final id = _generateId();
    await _database.insertTask(TasksCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      name: Value(name),
      description: Value(description),
      targetAmount: Value(targetAmount),
      categoryId: Value(categoryId),
      isRepeatable: Value(isRepeatable),
      unit: Value(unit),
    ));
  }

  Future<void> insertTask(TasksCompanion task) async {
    await _database.insertTask(task);
  }

  Future<void> updateTask(TasksCompanion task) async {
    await _database.updateTask(task);
  }

  Future<void> editTask(Task task) async {
    await _database.updateTask(TasksCompanion(
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
    ));
  }

  Future<void> deleteTask(String id) async {
    await _database.deleteTask(id);
  }

  Future<List<ProgressRecord>> getProgressRecords(String taskId) {
    return _database.getProgressRecordsByTask(taskId);
  }

  Future<void> addProgress(String taskId, int additionalAmount) async {
    final task = await _database.getTaskById(taskId);
    if (task == null) return;
    final newAmount = (task.completedAmount + additionalAmount).clamp(0, task.targetAmount);
    await _database.updateTaskProgress(taskId, newAmount);
  }

  Future<void> updateProgress(String taskId, int amount) async {
    await _database.updateTaskProgress(taskId, amount);
  }

  Future<void> insertProgressRecord(ProgressRecordsCompanion record) async {
    await _database.insertProgressRecord(record);
  }

  String _generateId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return '${timestamp.toRadixString(16).padLeft(8, '0')}-'
        '${(timestamp ^ 0xFFFF).toRadixString(16).padLeft(4, '0')}-'
        '4${(timestamp & 0x0FFF).toRadixString(16).padLeft(3, '0')}-'
        '${(timestamp & 0x3FFF | 0x8000).toRadixString(16).padLeft(4, '0')}-'
        '${(timestamp ^ 0xFFFFFFFF).toRadixString(16).padLeft(8, '0')}'
        '${timestamp.toRadixString(16).padLeft(4, '0')}';
  }
}
