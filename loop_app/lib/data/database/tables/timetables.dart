import 'package:drift/drift.dart';

@DataClassName('Timetable')
class Timetables extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get name => text().withLength(max: 50)();
  IntColumn get academicYear => integer()();
  IntColumn get semester => integer()();
  DateTimeColumn get firstWeekMonday => dateTime()();
  IntColumn get totalWeeks => integer().withDefault(const Constant(20))();
  IntColumn get currentWeek => integer().withDefault(const Constant(1))();
  TextColumn get source => text().nullable().withLength(max: 20)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
