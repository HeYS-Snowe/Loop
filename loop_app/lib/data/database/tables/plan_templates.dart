import 'package:drift/drift.dart';
import 'categories.dart';

@DataClassName('PlanTemplate')
class PlanTemplates extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get name => text().withLength(max: 30)();
  TextColumn get description => text().nullable().withLength(max: 200)();
  TextColumn get categoryId => text().nullable().withLength(min: 36, max: 36).references(Categories, #id)();
  IntColumn get dailyTargetAmount => integer().withDefault(const Constant(0))();
  TextColumn get unit => text().nullable().withLength(max: 10)();
  BoolColumn get enableQuantityTracking => boolean().withDefault(const Constant(true))();
  TextColumn get repeatType => text().withLength(max: 10).withDefault(const Constant('none'))();
  IntColumn get repeatInterval => integer().withDefault(const Constant(1))();
  TextColumn get activeDays => text().withDefault(const Constant('1,2,3,4,5,6,7'))();
  IntColumn get startHour => integer().withDefault(const Constant(8))();
  IntColumn get startMinute => integer().withDefault(const Constant(0))();
  IntColumn get endHour => integer().withDefault(const Constant(9))();
  IntColumn get endMinute => integer().withDefault(const Constant(0))();
  IntColumn get colorValue => integer().withDefault(const Constant(0xFF2196F3))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
