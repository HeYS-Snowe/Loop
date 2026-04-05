import 'package:drift/drift.dart';

@DataClassName('Cycle')
class Cycles extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get name => text().withLength(max: 30)();
  TextColumn get description => text().nullable().withLength(max: 200)();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get status =>
      text().withLength(max: 20).withDefault(const Constant('active'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
