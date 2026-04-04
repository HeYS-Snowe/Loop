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

  Future<void> insertTask(TasksCompanion task) async {
    await _database.insertTask(task);
  }

  Future<void> updateTask(TasksCompanion task) async {
    await _database.updateTask(task);
  }

  Future<void> deleteTask(String id) async {
    await _database.deleteTask(id);
  }

  Future<List<ProgressRecord>> getProgressRecords(String taskId) {
    return _database.getProgressRecordsByTask(taskId);
  }

  Future<void> insertProgressRecord(ProgressRecordsCompanion record) async {
    await _database.insertProgressRecord(record);
  }
}
