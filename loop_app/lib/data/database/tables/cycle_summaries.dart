import 'package:drift/drift.dart';
import 'cycles.dart';

@DataClassName('CycleSummary')
class CycleSummaries extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get cycleId => text().withLength(min: 36, max: 36).references(Cycles, #id)();
  RealColumn get completionRate => real().withDefault(const Constant(0.0))();
  IntColumn get totalTasks => integer().withDefault(const Constant(0))();
  IntColumn get completedTasks => integer().withDefault(const Constant(0))();
  IntColumn get totalCheckIns => integer().withDefault(const Constant(0))();
  IntColumn get maxStreak => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable().withLength(max: 500)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
