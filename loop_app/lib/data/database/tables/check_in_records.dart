import 'package:drift/drift.dart';

@DataClassName('CheckInRecord')
class CheckInRecords extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  DateTimeColumn get date => dateTime()();
  IntColumn get streakCount => integer().withDefault(const Constant(1))();
  TextColumn get note => text().nullable().withLength(max: 200)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
