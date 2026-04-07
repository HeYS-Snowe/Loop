import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/timetable_repository.dart';
import '../../domain/services/timetable_html_parser.dart';
import 'cycle_provider.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return TimetableRepository(ref.watch(databaseProvider));
});

final allTimetablesProvider = FutureProvider<List<Timetable>>((ref) {
  final repository = ref.watch(timetableRepositoryProvider);
  return repository.getAllTimetables();
});

final activeTimetableProvider = FutureProvider<Timetable?>((ref) {
  final repository = ref.watch(timetableRepositoryProvider);
  return repository.getActiveTimetable();
});

final todayCoursesProvider = FutureProvider<List<TimetableCourse>>((ref) async {
  final repository = ref.read(timetableRepositoryProvider);
  final timetable = await repository.getActiveTimetable();
  if (timetable == null) return [];

  final now = DateTime.now();
  final weekday = now.weekday;
  final courses = await repository.getCoursesByWeekday(timetable.id, weekday);

  return _filterByCurrentWeek(courses, timetable.currentWeek);
});

List<TimetableCourse> _filterByCurrentWeek(
  List<TimetableCourse> courses,
  int currentWeek,
) {
  return courses.where((course) {
    return _isWeekInRange(course.weekRanges, currentWeek);
  }).toList();
}

bool _isWeekInRange(String weekRanges, int week) {
  final pattern = RegExp(r'(\d+)(?:-(\d+))?');
  for (final match in pattern.allMatches(weekRanges)) {
    final start = int.parse(match.group(1)!);
    final endStr = match.group(2);
    final end = endStr != null ? int.parse(endStr) : start;
    if (week >= start && week <= end) return true;
  }
  return false;
}

final timetableDetailProvider =
    FutureProvider.family<Timetable?, String>((ref, id) {
  final repository = ref.watch(timetableRepositoryProvider);
  return repository.getTimetableById(id);
});

final coursesByTimetableProvider =
    FutureProvider.family<List<TimetableCourse>, String>((ref, timetableId) {
  final repository = ref.watch(timetableRepositoryProvider);
  return repository.getCoursesByTimetable(timetableId);
});

final coursesByWeekdayProvider = FutureProvider.family<List<TimetableCourse>,
    ({String timetableId, int weekday})>((ref, params) {
  final repository = ref.watch(timetableRepositoryProvider);
  return repository.getCoursesByWeekday(params.timetableId, params.weekday);
});

final coursesForDateProvider =
    FutureProvider.family<List<TimetableCourse>, DateTime>((ref, date) async {
  final repository = ref.read(timetableRepositoryProvider);
  final timetable = await repository.getActiveTimetable();
  if (timetable == null) return [];

  final weekday = date.weekday;
  final courses = await repository.getCoursesByWeekday(timetable.id, weekday);

  final firstMonday = timetable.firstWeekMonday;
  final diff = date.difference(DateTime(
    firstMonday.year,
    firstMonday.month,
    firstMonday.day,
  )).inDays;
  if (diff < 0) return [];
  final weekNumber = diff ~/ 7 + 1;
  if (weekNumber > timetable.totalWeeks) return [];

  return _filterByCurrentWeek(courses, weekNumber);
});

class TimetableNotifier extends AsyncNotifier<List<Timetable>> {
  @override
  Future<List<Timetable>> build() async {
    final repository = ref.watch(timetableRepositoryProvider);
    return repository.getAllTimetables();
  }

  TimetableRepository get _repository => ref.read(timetableRepositoryProvider);

  Future<Timetable> createTimetable({
    required String name,
    required int academicYear,
    required int semester,
    required DateTime firstWeekMonday,
    int totalWeeks = 20,
    int currentWeek = 1,
    String? source,
  }) async {
    final timetable = await _repository.createTimetable(
      name: name,
      academicYear: academicYear,
      semester: semester,
      firstWeekMonday: firstWeekMonday,
      totalWeeks: totalWeeks,
      currentWeek: currentWeek,
      source: source,
    );
    ref.invalidateSelf();
    return timetable;
  }

  Future<void> deleteTimetable(String id) async {
    await _repository.deleteTimetable(id);
    ref.invalidateSelf();
  }

  Future<void> updateTimetable(Timetable timetable) async {
    await _repository.updateTimetable(timetable);
    ref.invalidateSelf();
  }
}

final timetableNotifierProvider =
    AsyncNotifierProvider<TimetableNotifier, List<Timetable>>(
  TimetableNotifier.new,
);

class TimetableCourseNotifier extends AsyncNotifier<List<TimetableCourse>> {
  String? _currentTimetableId;

  @override
  Future<List<TimetableCourse>> build() async {
    return [];
  }

  TimetableRepository get _repository => ref.read(timetableRepositoryProvider);

  String? get currentTimetableId => _currentTimetableId;

  Future<void> loadCourses(String timetableId) async {
    _currentTimetableId = timetableId;
    state = AsyncValue.data(
        await _repository.getCoursesByTimetable(timetableId));
  }

  Future<void> createCourse({
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
    await _repository.createCourse(
      timetableId: timetableId,
      courseName: courseName,
      teacherName: teacherName,
      location: location,
      weekday: weekday,
      startPeriod: startPeriod,
      endPeriod: endPeriod,
      weekRanges: weekRanges,
      colorHex: colorHex,
    );
    state = AsyncValue.data(
        await _repository.getCoursesByTimetable(timetableId));
  }

  Future<void> deleteCourse(String courseId, String timetableId) async {
    await _repository.deleteCourse(courseId);
    state = AsyncValue.data(
        await _repository.getCoursesByTimetable(timetableId));
  }

  Future<Timetable> importFromHtml(
      String htmlContent, String timetableName) async {
    final parsed = TimetableHtmlParser.parse(htmlContent);

    if (parsed.courses.isEmpty) {
      throw Exception('noCourseData');
    }

    final timetable = await _repository.createTimetable(
      name: timetableName,
      academicYear: parsed.academicYear,
      semester: parsed.semester,
      firstWeekMonday: parsed.firstWeekMonday,
      totalWeeks: parsed.totalWeeks,
      source: 'html',
    );

    final courses =
        TimetableHtmlParser.toTimetableCourses(timetable.id, parsed.courses);
    await _repository.importCourses(timetable.id, courses);

    _currentTimetableId = timetable.id;
    state = AsyncValue.data(courses);
    return timetable;
  }

  Future<Timetable> importFromFolder(
      String folderPath, String timetableName) async {
    final parsed = await TimetableHtmlParser.parseFromFolder(folderPath);

    final timetable = await _repository.createTimetable(
      name: timetableName,
      academicYear: parsed.academicYear,
      semester: parsed.semester,
      firstWeekMonday: parsed.firstWeekMonday,
      totalWeeks: parsed.totalWeeks,
      source: 'html',
    );

    final courses =
        TimetableHtmlParser.toTimetableCourses(timetable.id, parsed.courses);
    await _repository.importCourses(timetable.id, courses);

    _currentTimetableId = timetable.id;
    state = AsyncValue.data(courses);
    return timetable;
  }
}

final timetableCourseNotifierProvider =
    AsyncNotifierProvider<TimetableCourseNotifier, List<TimetableCourse>>(
  TimetableCourseNotifier.new,
);
