import 'package:drift/drift.dart';
import 'tasks.dart';

@DataClassName('ProgressRecord')
class ProgressRecords extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get taskId => text().withLength(min: 36, max: 36).references(Tasks, #id)();
  DateTimeColumn get date => dateTime()();
  IntColumn get amount => integer().check(amount.isBiggerThanValue(0))();
  TextColumn get note => text().nullable().withLength(max: 200)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
