import 'package:drift/drift.dart';
import '../database/app_database.dart';

class PlanInstanceRepository {
  final AppDatabase _database;

  PlanInstanceRepository(this._database);

  Future<List<PlanInstance>> getInstancesByDate(DateTime date) {
    return _database.getPlanInstancesByDate(date);
  }

  Future<List<PlanInstance>> getInstancesByDateRange(DateTime start, DateTime end) {
    return _database.getPlanInstancesByDateRange(start, end);
  }

  Future<void> ensureInstancesForDate(DateTime date) async {
    final templates = await _database.getAllPlanTemplates();
    final existing = await _database.getPlanInstancesByDate(date);

    for (final template in templates) {
      if (!template.isActive) continue;
      if (!_shouldCreateInstance(template, date)) continue;

      final alreadyExists = existing.any((e) => e.planTemplateId == template.id);
      if (alreadyExists) continue;

      await _database.insertPlanInstance(PlanInstancesCompanion(
        id: Value(_generateId()),
        planTemplateId: Value(template.id),
        date: Value(DateTime(date.year, date.month, date.day)),
        targetAmount: Value(template.dailyTargetAmount),
        completedAmount: const Value(0),
        isCompleted: const Value(false),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ));
    }
  }

  Future<void> updateInstance(PlanInstance instance) async {
    await _database.updatePlanInstance(PlanInstancesCompanion(
      id: Value(instance.id),
      planTemplateId: Value(instance.planTemplateId),
      date: Value(instance.date),
      targetAmount: Value(instance.targetAmount),
      completedAmount: Value(instance.completedAmount),
      isCompleted: Value(instance.isCompleted),
      note: Value(instance.note),
      createdAt: Value(instance.createdAt),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> completeInstance(String id) async {
    await _database.completePlanInstance(id);
  }

  Future<void> uncompleteInstance(String id) async {
    await _database.uncompletePlanInstance(id);
  }

  bool _shouldCreateInstance(PlanTemplate template, DateTime date) {
    if (template.repeatType == 'none') {
      final templateStart = DateTime(
        template.startDate.year,
        template.startDate.month,
        template.startDate.day,
      );
      final checkDate = DateTime(date.year, date.month, date.day);
      return checkDate.isAtSameMomentAs(templateStart);
    }

    final weekday = date.weekday;
    final activeDays = template.activeDays.split(',').map(int.parse).toList();
    return activeDays.contains(weekday);
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
