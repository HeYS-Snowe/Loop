import 'package:drift/drift.dart';
import '../database/app_database.dart';

class PlanInstanceRepository {
  final AppDatabase _database;

  PlanInstanceRepository(this._database);

  Future<List<PlanInstance>> getInstancesByDate(DateTime date) =>
      _database.getPlanInstancesByDate(date);

  Stream<List<PlanInstance>> watchInstancesByDate(DateTime date) =>
      _database.watchPlanInstancesByDate(date);

  Future<List<PlanInstance>> getInstancesByDateRange(
          DateTime start, DateTime end) =>
      _database.getPlanInstancesByDateRange(start, end);

  Future<PlanInstance?> getInstance(String templateId, DateTime date) =>
      _database.getPlanInstance(templateId, date);

  Future<void> updateCompletedAmount(String instanceId, int amount) async {
    final instance = await _database.getPlanInstance(
        (await _database.getPlanInstancesByDate(DateTime.now()))
            .firstWhere((i) => i.id == instanceId,
                orElse: () => throw StateError('Instance not found'))
            .planTemplateId,
        DateTime.now());

    if (instance != null) {
      await _database.updatePlanInstance(
        PlanInstancesCompanion(
          id: Value(instanceId),
          completedAmount: Value(amount),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<void> updateInstance(PlanInstance instance) async {
    await _database.updatePlanInstance(
      PlanInstancesCompanion(
        id: Value(instance.id),
        planTemplateId: Value(instance.planTemplateId),
        date: Value(instance.date),
        targetAmount: Value(instance.targetAmount),
        completedAmount: Value(instance.completedAmount),
        isCompleted: Value(instance.isCompleted),
        note: Value(instance.note),
        createdAt: Value(instance.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> completeInstance(String instanceId) async {
    final instances = await _database.getPlanInstancesByDate(DateTime.now());
    final instance = instances.firstWhere(
        (i) => i.id == instanceId,
        orElse: () => throw StateError('Instance not found: $instanceId'));

    await _database.updatePlanInstance(
      PlanInstancesCompanion(
        id: Value(instanceId),
        completedAmount: Value(instance.targetAmount),
        isCompleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> uncompleteInstance(String instanceId) async {
    await _database.updatePlanInstance(
      PlanInstancesCompanion(
        id: Value(instanceId),
        isCompleted: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> ensureInstancesForDate(DateTime date) =>
      _database.ensurePlanInstancesForDate(date);
}
