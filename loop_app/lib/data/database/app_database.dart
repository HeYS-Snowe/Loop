import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'database_connection.dart'
    if (dart.library.js) 'database_connection_web.dart';
import 'tables/cycles.dart';
import 'tables/tasks.dart';
import 'tables/progress_records.dart';
import 'tables/check_in_records.dart';
import 'tables/categories.dart';
import 'tables/cycle_summaries.dart';
import 'tables/plan_templates.dart';
import 'tables/plan_instances.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Cycles,
  Tasks,
  ProgressRecords,
  CheckInRecords,
  Categories,
  CycleSummaries,
  PlanTemplates,
  PlanInstances,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(planTemplates);
          await m.createTable(planInstances);
        }
        if (from < 3) {
          await m.addColumn(planTemplates, planTemplates.startHour);
          await m.addColumn(planTemplates, planTemplates.startMinute);
          await m.addColumn(planTemplates, planTemplates.endHour);
          await m.addColumn(planTemplates, planTemplates.endMinute);
          await m.addColumn(planTemplates, planTemplates.colorValue);
        }
      },
    );
  }

  Future<List<Cycle>> getAllCycles() => select(cycles).get();

  Stream<List<Cycle>> watchAllCycles() => select(cycles).watch();

  Future<Cycle?> getCycleById(String id) {
    return (select(cycles)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  Future<Cycle?> getActiveCycle() {
    return (select(cycles)..where((c) => c.isActive.equals(true))).getSingleOrNull();
  }

  Future<String> insertCycle(CyclesCompanion cycle) async {
    await into(cycles).insert(cycle);
    return cycle.id.value;
  }

  Future<void> updateCycle(CyclesCompanion cycle) async {
    await (update(cycles)..where((c) => c.id.equals(cycle.id.value))).write(cycle);
  }

  Future<void> deleteCycle(String id) async {
    await (delete(cycles)..where((c) => c.id.equals(id))).go();
  }

  Future<List<Task>> getTasksByCycle(String cycleId) {
    return (select(tasks)..where((t) => t.cycleId.equals(cycleId))).get();
  }

  Stream<List<Task>> watchTasksByCycle(String cycleId) {
    return (select(tasks)..where((t) => t.cycleId.equals(cycleId))).watch();
  }

  Future<Task?> getTaskById(String id) {
    return (select(tasks)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<String> insertTask(TasksCompanion task) async {
    await into(tasks).insert(task);
    return task.id.value;
  }

  Future<void> updateTask(TasksCompanion task) async {
    await (update(tasks)..where((t) => t.id.equals(task.id.value))).write(task);
  }

  Future<void> deleteTask(String id) async {
    await (delete(tasks)..where((t) => t.id.equals(id))).go();
  }

  Future<List<ProgressRecord>> getProgressRecordsByTask(String taskId) {
    return (select(progressRecords)..where((p) => p.taskId.equals(taskId))).get();
  }

  Future<String> insertProgressRecord(ProgressRecordsCompanion record) async {
    await into(progressRecords).insert(record);
    return record.id.value;
  }

  Future<List<CheckInRecord>> getCheckInRecords() {
    return (select(checkInRecords)..orderBy([(t) => OrderingTerm.desc(t.date)])).get();
  }

  Future<CheckInRecord?> getCheckInRecordByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (select(checkInRecords)
          ..where((c) =>
              c.date.isBiggerOrEqualValue(startOfDay) &
              c.date.isSmallerThanValue(endOfDay)))
        .getSingleOrNull();
  }

  Future<CheckInRecord?> getLastCheckInRecord() {
    return (select(checkInRecords)..orderBy([(t) => OrderingTerm.desc(t.date)])).getSingleOrNull();
  }

  Future<String> insertCheckInRecord(CheckInRecordsCompanion record) async {
    await into(checkInRecords).insert(record);
    return record.id.value;
  }

  Future<List<Category>> getAllCategories() {
    return (select(categories)..orderBy([(c) => OrderingTerm.asc(c.sortOrder)])).get();
  }

  Future<Category?> getCategoryById(String id) {
    return (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  Future<String> insertCategory(CategoriesCompanion category) async {
    await into(categories).insert(category);
    return category.id.value;
  }

  Future<void> updateCategory(CategoriesCompanion category) async {
    await (update(categories)..where((c) => c.id.equals(category.id.value))).write(category);
  }

  Future<void> deleteCategory(String id) async {
    await (delete(categories)..where((c) => c.id.equals(id))).go();
  }

  Future<List<PlanTemplate>> getAllPlanTemplates() {
    return (select(planTemplates)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
  }

  Future<PlanTemplate?> getPlanTemplateById(String id) {
    return (select(planTemplates)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<String> insertPlanTemplate(PlanTemplatesCompanion template) async {
    await into(planTemplates).insert(template);
    return template.id.value;
  }

  Future<void> updatePlanTemplate(PlanTemplatesCompanion template) async {
    await (update(planTemplates)..where((t) => t.id.equals(template.id.value))).write(template);
  }

  Future<void> deletePlanTemplate(String id) async {
    await (delete(planTemplates)..where((t) => t.id.equals(id))).go();
  }

  Future<List<PlanInstance>> getPlanInstancesByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (select(planInstances)
          ..where((p) =>
              p.date.isBiggerOrEqualValue(startOfDay) &
              p.date.isSmallerThanValue(endOfDay)))
        .get();
  }

  Stream<List<PlanInstance>> watchPlanInstancesByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (select(planInstances)
          ..where((p) =>
              p.date.isBiggerOrEqualValue(startOfDay) &
              p.date.isSmallerThanValue(endOfDay)))
        .watch();
  }

  Future<List<PlanInstance>> getPlanInstancesByDateRange(
      DateTime start, DateTime end) {
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day)
        .add(const Duration(days: 1));
    return (select(planInstances)
          ..where((p) =>
              p.date.isBiggerOrEqualValue(startDate) &
              p.date.isSmallerThanValue(endDate)))
        .get();
  }

  Future<PlanInstance?> getPlanInstance(String templateId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final results = await (select(planInstances)
          ..where((p) =>
              p.planTemplateId.equals(templateId) &
              p.date.isBiggerOrEqualValue(startOfDay) &
              p.date.isSmallerThanValue(endOfDay)))
        .get();
    if (results.isEmpty) return null;
    if (results.length == 1) return results.single;
    return results.first;
  }

  Future<String> insertPlanInstance(PlanInstancesCompanion instance) async {
    await into(planInstances).insert(instance);
    return instance.id.value;
  }

  Future<void> updatePlanInstance(PlanInstancesCompanion instance) async {
    await (update(planInstances)
          ..where((p) => p.id.equals(instance.id.value)))
        .write(instance);
  }

  Future<void> ensurePlanInstancesForDate(DateTime date) async {
    final templates = await getAllPlanTemplates();
    final dateWeekday = date.weekday;

    for (final template in templates) {
      final activeDaysList = template.activeDays
          .split(',')
          .map((s) => int.tryParse(s.trim()) ?? 0)
          .where((d) => d >= 1 && d <= 7)
          .toList();

      if (!activeDaysList.contains(dateWeekday)) continue;

      if (!_isDateInRange(date, template)) continue;

      final existing = await getPlanInstance(template.id, date);
      if (existing != null) continue;

      await insertPlanInstance(PlanInstancesCompanion(
        id: Value(const Uuid().v4()),
        planTemplateId: Value(template.id),
        date: Value(date),
        targetAmount: Value(template.dailyTargetAmount),
        completedAmount: const Value(0),
        isCompleted: const Value(false),
        note: const Value.absent(),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ));
    }
  }

  bool _isDateInRange(DateTime date, PlanTemplate template) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final startDate = DateTime(template.startDate.year, template.startDate.month, template.startDate.day);
    if (dateOnly.isBefore(startDate)) return false;
    if (template.endDate != null) {
      final endDate = DateTime(template.endDate!.year, template.endDate!.month, template.endDate!.day);
      if (dateOnly.isAfter(endDate)) return false;
    }
    return true;
  }
}
