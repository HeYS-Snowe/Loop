import 'package:drift/drift.dart';

import 'tables/cycles.dart';
import 'tables/tasks.dart';
import 'tables/progress_records.dart';
import 'tables/check_in_records.dart';
import 'tables/categories.dart';
import 'tables/cycle_summaries.dart';
import 'tables/plan_templates.dart';
import 'tables/plan_instances.dart';
import 'tables/timetables.dart';
import 'tables/timetable_courses.dart';

import 'database_connection_stub.dart'
    if (dart.library.io) 'database_connection.dart'
    if (dart.library.js_interop) 'database_connection_web.dart';

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
  Timetables,
  TimetableCourses,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

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
          await m.createTable(timetables);
          await m.createTable(timetableCourses);
        }
        if (from < 4) {
          await customStatement(
            'ALTER TABLE plan_templates ADD COLUMN enable_time_slot INTEGER NOT NULL DEFAULT 1',
          );
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
    return (select(cycles)
          ..where((c) => c.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<String> insertCycle(CyclesCompanion cycle) async {
    await into(cycles).insert(cycle);
    return cycle.id.value;
  }

  Future<void> updateCycle(CyclesCompanion cycle) async {
    await (update(cycles)..where((c) => c.id.equals(cycle.id.value)))
        .write(cycle);
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

  Future<void> updateTaskProgress(String taskId, int amount) async {
    await (update(tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(
        completedAmount: Value(amount),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteTask(String id) async {
    await (delete(tasks)..where((t) => t.id.equals(id))).go();
  }

  Future<List<ProgressRecord>> getProgressByTask(String taskId) {
    return (select(progressRecords)..where((p) => p.taskId.equals(taskId)))
        .get();
  }

  Future<String> insertProgressRecord(ProgressRecordsCompanion record) async {
    await into(progressRecords).insert(record);
    return record.id.value;
  }

  Future<List<CheckInRecord>> getAllCheckIns() {
    return (select(checkInRecords)..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Stream<List<CheckInRecord>> watchAllCheckIns() {
    return (select(checkInRecords)..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Future<CheckInRecord?> getCheckInByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final rows = await (select(checkInRecords)
          ..where((c) =>
              c.date.isBiggerOrEqualValue(startOfDay) &
              c.date.isSmallerThanValue(endOfDay))
          ..limit(1))
        .get();
    return rows.firstOrNull;
  }

  Future<CheckInRecord?> getLastCheckIn() {
    return (select(checkInRecords)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<String> insertCheckIn(CheckInRecordsCompanion record) async {
    await into(checkInRecords).insert(record);
    return record.id.value;
  }

  Future<List<Category>> getAllCategories() {
    return (select(categories)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Stream<List<Category>> watchAllCategories() {
    return (select(categories)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  Future<String> insertCategory(CategoriesCompanion category) async {
    await into(categories).insert(category);
    return category.id.value;
  }

  Future<void> deleteCategory(String id) async {
    await (delete(categories)..where((c) => c.id.equals(id))).go();
  }

  Future<CycleSummary?> getSummaryByCycle(String cycleId) {
    return (select(cycleSummaries)..where((s) => s.cycleId.equals(cycleId)))
        .getSingleOrNull();
  }

  Future<String> insertCycleSummary(CycleSummariesCompanion summary) async {
    await into(cycleSummaries).insert(summary);
    return summary.id.value;
  }

  Future<void> clearAllData() async {
    await delete(planInstances).go();
    await delete(planTemplates).go();
    await delete(timetableCourses).go();
    await delete(timetables).go();
    await delete(progressRecords).go();
    await delete(tasks).go();
    await delete(checkInRecords).go();
    await delete(cycleSummaries).go();
    await delete(cycles).go();
    await delete(categories).go();
  }

  Future<List<PlanTemplate>> getAllPlanTemplates() {
    return (select(planTemplates)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Stream<List<PlanTemplate>> watchAllPlanTemplates() {
    return (select(planTemplates)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  Future<PlanTemplate?> getPlanTemplateById(String id) {
    return (select(planTemplates)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Timetable>> getAllTimetables() => select(timetables).get();

  Stream<List<Timetable>> watchAllTimetables() => select(timetables).watch();

  Future<Timetable?> getTimetableById(String id) {
    return (select(timetables)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<Timetable?> getActiveTimetable() {
    return (select(timetables)..limit(1)).getSingleOrNull();
  }

  Future<String> insertTimetable(TimetablesCompanion timetable) async {
    await into(timetables).insert(timetable);
    return timetable.id.value;
  }

  Future<void> updateTimetable(TimetablesCompanion timetable) async {
    await (update(timetables)..where((t) => t.id.equals(timetable.id.value)))
        .write(timetable);
  }

  Future<void> deleteTimetable(String id) async {
    await (delete(timetableCourses)..where((c) => c.timetableId.equals(id)))
        .go();
    await (delete(timetables)..where((t) => t.id.equals(id))).go();
  }

  Future<List<TimetableCourse>> getCoursesByTimetable(String timetableId) {
    return (select(timetableCourses)
          ..where((c) => c.timetableId.equals(timetableId)))
        .get();
  }

  Stream<List<TimetableCourse>> watchCoursesByTimetable(String timetableId) {
    return (select(timetableCourses)
          ..where((c) => c.timetableId.equals(timetableId)))
        .watch();
  }

  Future<List<TimetableCourse>> getCoursesByWeekday(
      String timetableId, int weekday) {
    return (select(timetableCourses)
          ..where(
              (c) => c.timetableId.equals(timetableId) & c.weekday.equals(weekday)))
        .get();
  }

  Future<String> insertCourse(TimetableCoursesCompanion course) async {
    await into(timetableCourses).insert(course);
    return course.id.value;
  }

  Future<void> insertCourses(List<TimetableCoursesCompanion> courses) async {
    await batch((b) {
      b.insertAll(timetableCourses, courses);
    });
  }

  Future<void> updateCourse(TimetableCoursesCompanion course) async {
    await (update(timetableCourses)..where((c) => c.id.equals(course.id.value)))
        .write(course);
  }

  Future<void> deleteCourse(String id) async {
    await (delete(timetableCourses)..where((c) => c.id.equals(id))).go();
  }

  /// 导出全部数据为 JSON Map
  Future<Map<String, dynamic>> exportToJson() async {
    return {
      'schemaVersion': schemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'cycles': (await select(cycles).get())
          .map((e) => e.toJson()).toList(),
      'tasks': (await select(tasks).get())
          .map((e) => e.toJson()).toList(),
      'checkInRecords': (await select(checkInRecords).get())
          .map((e) => e.toJson()).toList(),
      'categories': (await select(categories).get())
          .map((e) => e.toJson()).toList(),
      'cycleSummaries': (await select(cycleSummaries).get())
          .map((e) => e.toJson()).toList(),
      'planTemplates': (await select(planTemplates).get())
          .map((e) => e.toJson()).toList(),
      'planInstances': (await select(planInstances).get())
          .map((e) => e.toJson()).toList(),
      'timetables': (await select(timetables).get())
          .map((e) => e.toJson()).toList(),
      'timetableCourses': (await select(timetableCourses).get())
          .map((e) => e.toJson()).toList(),
    };
  }
}

LazyDatabase _openConnection() => openConnection();
