import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

class TimetableRepository {
  final AppDatabase _database;
  final _uuid = const Uuid();

  TimetableRepository(this._database);

  Future<List<Timetable>> getAllTimetables() =>
      _database.getAllTimetables();

  Stream<List<Timetable>> watchAllTimetables() =>
      _database.watchAllTimetables();

  Future<Timetable?> getTimetableById(String id) =>
      _database.getTimetableById(id);

  Future<Timetable?> getActiveTimetable() =>
      _database.getActiveTimetable();

  Future<Timetable> createTimetable({
    required String name,
    required int academicYear,
    required int semester,
    required DateTime firstWeekMonday,
    int totalWeeks = 20,
    int currentWeek = 1,
    String? source,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    await _database.insertTimetable(
      TimetablesCompanion(
        id: Value(id),
        name: Value(name),
        academicYear: Value(academicYear),
        semester: Value(semester),
        firstWeekMonday: Value(firstWeekMonday),
        totalWeeks: Value(totalWeeks),
        currentWeek: Value(currentWeek),
        source: Value(source),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    return Timetable(
      id: id,
      name: name,
      academicYear: academicYear,
      semester: semester,
      firstWeekMonday: firstWeekMonday,
      totalWeeks: totalWeeks,
      currentWeek: currentWeek,
      source: source,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<void> updateTimetable(Timetable timetable) async {
    await _database.updateTimetable(
      TimetablesCompanion(
        id: Value(timetable.id),
        name: Value(timetable.name),
        academicYear: Value(timetable.academicYear),
        semester: Value(timetable.semester),
        firstWeekMonday: Value(timetable.firstWeekMonday),
        totalWeeks: Value(timetable.totalWeeks),
        currentWeek: Value(timetable.currentWeek),
        source: Value(timetable.source),
        createdAt: Value(timetable.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteTimetable(String id) =>
      _database.deleteTimetable(id);

  Future<List<TimetableCourse>> getCoursesByTimetable(String timetableId) =>
      _database.getCoursesByTimetable(timetableId);

  Stream<List<TimetableCourse>> watchCoursesByTimetable(String timetableId) =>
      _database.watchCoursesByTimetable(timetableId);

  Future<List<TimetableCourse>> getCoursesByWeekday(
          String timetableId, int weekday) =>
      _database.getCoursesByWeekday(timetableId, weekday);

  Future<TimetableCourse> createCourse({
    required String timetableId,
    required String courseName,
    String? teacherName,
    String? location,
    required int weekday,
    required int startPeriod,
    required int endPeriod,
    required String weekRanges,
    String? colorHex,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    await _database.insertCourse(
      TimetableCoursesCompanion(
        id: Value(id),
        timetableId: Value(timetableId),
        courseName: Value(courseName),
        teacherName: Value(teacherName),
        location: Value(location),
        weekday: Value(weekday),
        startPeriod: Value(startPeriod),
        endPeriod: Value(endPeriod),
        weekRanges: Value(weekRanges),
        colorHex: Value(colorHex),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    return TimetableCourse(
      id: id,
      timetableId: timetableId,
      courseName: courseName,
      teacherName: teacherName,
      location: location,
      weekday: weekday,
      startPeriod: startPeriod,
      endPeriod: endPeriod,
      weekRanges: weekRanges,
      colorHex: colorHex,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<void> importCourses(
      String timetableId, List<TimetableCourse> courses) async {
    final companions = courses.map((course) {
      return TimetableCoursesCompanion(
        id: Value(course.id),
        timetableId: Value(timetableId),
        courseName: Value(course.courseName),
        teacherName: Value(course.teacherName),
        location: Value(course.location),
        weekday: Value(course.weekday),
        startPeriod: Value(course.startPeriod),
        endPeriod: Value(course.endPeriod),
        weekRanges: Value(course.weekRanges),
        colorHex: Value(course.colorHex),
        createdAt: Value(course.createdAt),
        updatedAt: Value(course.updatedAt),
      );
    }).toList();

    await _database.insertCourses(companions);
  }

  Future<void> updateCourse(TimetableCourse course) async {
    await _database.updateCourse(
      TimetableCoursesCompanion(
        id: Value(course.id),
        timetableId: Value(course.timetableId),
        courseName: Value(course.courseName),
        teacherName: Value(course.teacherName),
        location: Value(course.location),
        weekday: Value(course.weekday),
        startPeriod: Value(course.startPeriod),
        endPeriod: Value(course.endPeriod),
        weekRanges: Value(course.weekRanges),
        colorHex: Value(course.colorHex),
        createdAt: Value(course.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteCourse(String id) => _database.deleteCourse(id);
}
