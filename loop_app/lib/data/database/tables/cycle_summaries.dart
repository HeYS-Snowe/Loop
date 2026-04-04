import 'package:drift/drift.dart';
import 'cycles.dart';

@DataClassName('CycleSummary')
class CycleSummaries extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get cycleId => text().withLength(min: 36, max: 36).references(Cycles, #id)();
  RealColumn get completionRate => real()();
  IntColumn get totalTasks => integer()();
  IntColumn get completedTasks => integer()();
  IntColumn get totalCheckIns => integer()();
  IntColumn get maxStreak => integer()();
  TextColumn get summary => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
