import 'package:drift/drift.dart';
import 'timetables.dart';

@DataClassName('TimetableCourse')
class TimetableCourses extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get timetableId =>
      text().withLength(min: 36, max: 36).references(Timetables, #id)();
  TextColumn get courseName => text().withLength(max: 100)();
  TextColumn get teacherName => text().nullable().withLength(max: 50)();
  TextColumn get location => text().nullable().withLength(max: 100)();
  IntColumn get weekday => integer().check(weekday.isBiggerOrEqualValue(1) & weekday.isSmallerOrEqualValue(7))();
  IntColumn get startPeriod => integer().check(startPeriod.isBiggerOrEqualValue(1))();
  IntColumn get endPeriod => integer().check(endPeriod.isBiggerOrEqualValue(1))();
  TextColumn get weekRanges => text().withLength(max: 200)();
  TextColumn get colorHex => text().nullable().withLength(max: 7)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
