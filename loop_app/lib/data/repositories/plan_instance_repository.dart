import 'package:drift/drift.dart';
import 'package:loop_app/data/database/app_database.dart';
import 'package:uuid/uuid.dart';

class PlanInstanceRepository {
  final AppDatabase _database;
  final _uuid = const Uuid();

  PlanInstanceRepository(this._database);

  Future<List<PlanInstance>> getInstancesByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (_database.select(_database.planInstances)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerThanValue(end)))
        .get();
  }

  Future<List<PlanInstance>> getInstancesByDateRange(
      DateTime start, DateTime end) async {
    final rangeStart = DateTime(start.year, start.month, start.day);
    final rangeEnd = DateTime(end.year, end.month, end.day)
        .add(const Duration(days: 1));
    return (_database.select(_database.planInstances)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(rangeStart) &
              t.date.isSmallerThanValue(rangeEnd)))
        .get();
  }

  Future<void> ensureInstancesForDate(DateTime date) async {
    final templates = await _database.getAllPlanTemplates();
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final weekday = normalizedDate.weekday;
    final existing = await getInstancesByDate(normalizedDate);
    final existingTemplateIds =
        existing.map((e) => e.planTemplateId).toSet();

    for (final template in templates) {
      if (existingTemplateIds.contains(template.id)) continue;

      final activeDays = template.activeDays
          .split(',')
          .map(int.parse)
          .toList();
      if (!activeDays.contains(weekday)) continue;

      final now = DateTime.now();
      await _database.into(_database.planInstances).insert(
            PlanInstancesCompanion.insert(
              id: _uuid.v4(),
              planTemplateId: template.id,
              date: normalizedDate,
              targetAmount: Value(template.dailyTargetAmount),
              completedAmount: const Value(0),
              isCompleted: const Value(false),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    }
  }

  Future<void> updateInstance(PlanInstance instance) async {
    await _database.update(_database.planInstances).replace(instance);
  }

  Future<void> completeInstance(String instanceId) async {
    await (_database.update(_database.planInstances)
          ..where((t) => t.id.equals(instanceId)))
        .write(const PlanInstancesCompanion(
      isCompleted: Value(true),
    ));
  }

  Future<void> uncompleteInstance(String instanceId) async {
    await (_database.update(_database.planInstances)
          ..where((t) => t.id.equals(instanceId)))
        .write(const PlanInstancesCompanion(
      isCompleted: Value(false),
      completedAmount: Value(0),
    ));
  }
}
