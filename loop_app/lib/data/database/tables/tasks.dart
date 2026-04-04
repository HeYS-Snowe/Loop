import 'package:drift/drift.dart';
import 'cycles.dart';
import 'categories.dart';

@DataClassName('Task')
class Tasks extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get cycleId => text().withLength(min: 36, max: 36).references(Cycles, #id)();
  TextColumn get name => text().withLength(max: 50)();
  TextColumn get description => text().nullable().withLength(max: 200)();
  IntColumn get targetAmount => integer().check(targetAmount.isBiggerThanValue(0))();
  IntColumn get completedAmount => integer().withDefault(const Constant(0))();
  TextColumn get unit => text().nullable().withLength(max: 10)();
  TextColumn get categoryId => text().nullable().withLength(min: 36, max: 36).references(Categories, #id)();
  BoolColumn get isRepeatable => boolean().withDefault(const Constant(false))();
  TextColumn get repeatType => text().nullable().withLength(max: 10)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
