import 'package:drift/drift.dart';
import 'plan_templates.dart';

@DataClassName('PlanInstance')
class PlanInstances extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get planTemplateId => text().withLength(min: 36, max: 36).references(PlanTemplates, #id)();
  DateTimeColumn get date => dateTime()();
  IntColumn get targetAmount => integer().withDefault(const Constant(0))();
  IntColumn get completedAmount => integer().withDefault(const Constant(0))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get note => text().nullable().withLength(max: 200)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
