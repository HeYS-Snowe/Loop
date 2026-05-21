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
      if (!template.isActive) continue;

      final normalizedStart = DateTime(
        template.startDate.year,
        template.startDate.month,
        template.startDate.day,
      );
      if (normalizedDate.isBefore(normalizedStart)) continue;

      if (template.endDate != null) {
        final normalizedEnd = DateTime(
          template.endDate!.year,
          template.endDate!.month,
          template.endDate!.day,
        );
        if (normalizedDate.isAfter(normalizedEnd)) continue;
      }

      if (template.repeatType == 'none') {
        if (normalizedDate != normalizedStart) continue;
      } else if (template.repeatType == 'interval') {
        final diffDays = normalizedDate.difference(normalizedStart).inDays;
        if (diffDays < 0) continue;
        final interval = template.repeatInterval;
        if (interval <= 0) continue;
        if (diffDays % (interval + 1) != 0) continue;
      } else if (template.repeatType == 'monthly') {
        final activeDays = template.activeDays
            .split(',')
            .map(int.parse)
            .toList();
        if (!activeDays.contains(normalizedDate.day)) continue;
      } else {
        final activeDays = template.activeDays
            .split(',')
            .map(int.parse)
            .toList();
        if (!activeDays.contains(weekday)) continue;
      }

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

  Future<void> updateInstancesByTemplateAndDateRange({
    required String templateId,
    required DateTime rangeStart,
    required DateTime rangeEnd,
    required int targetAmount,
  }) async {
    final normalizedStart = DateTime(rangeStart.year, rangeStart.month, rangeStart.day);
    final normalizedEnd = DateTime(rangeEnd.year, rangeEnd.month, rangeEnd.day)
        .add(const Duration(days: 1));
    await (_database.update(_database.planInstances)
          ..where((t) =>
              t.planTemplateId.equals(templateId) &
              t.date.isBiggerOrEqualValue(normalizedStart) &
              t.date.isSmallerThanValue(normalizedEnd)))
        .write(PlanInstancesCompanion(
      targetAmount: Value(targetAmount),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> updateInstancesByTemplateExcludeDate({
    required String templateId,
    required DateTime excludeDate,
    required int targetAmount,
  }) async {
    final normalizedExclude = DateTime(excludeDate.year, excludeDate.month, excludeDate.day);
    await (_database.update(_database.planInstances)
          ..where((t) =>
              t.planTemplateId.equals(templateId) &
              t.date.isBiggerThanValue(normalizedExclude)))
        .write(PlanInstancesCompanion(
      targetAmount: Value(targetAmount),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> updateInstancesByTemplateBeforeDate({
    required String templateId,
    required DateTime beforeDate,
    required int targetAmount,
  }) async {
    final normalizedBefore = DateTime(beforeDate.year, beforeDate.month, beforeDate.day);
    await (_database.update(_database.planInstances)
          ..where((t) =>
              t.planTemplateId.equals(templateId) &
              t.date.isSmallerThanValue(normalizedBefore)))
        .write(PlanInstancesCompanion(
      targetAmount: Value(targetAmount),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> updateAllInstancesByTemplate({
    required String templateId,
    required int targetAmount,
  }) async {
    await (_database.update(_database.planInstances)
          ..where((t) => t.planTemplateId.equals(templateId)))
        .write(PlanInstancesCompanion(
      targetAmount: Value(targetAmount),
      updatedAt: Value(DateTime.now()),
    ));
  }
}
