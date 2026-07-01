import 'package:drift/drift.dart';
import 'package:loop_app/data/database/app_database.dart';
import 'package:loop_app/data/models/create_plan_template_params.dart';
import 'package:uuid/uuid.dart';

class PlanTemplateRepository {
  final AppDatabase _database;
  final _uuid = const Uuid();

  PlanTemplateRepository(this._database);

  Future<List<PlanTemplate>> getAllTemplates() {
    return _database.getAllPlanTemplates();
  }

  Future<PlanTemplate?> getTemplateById(String id) {
    return _database.getPlanTemplateById(id);
  }

  Future<void> createTemplate(CreatePlanTemplateParams params) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await _database.into(_database.planTemplates).insert(
          PlanTemplatesCompanion.insert(
            id: id,
            name: params.name,
            description: Value(params.description),
            categoryId: Value(params.categoryId),
            dailyTargetAmount: Value(params.dailyTargetAmount),
            unit: Value(params.unit),
            enableQuantityTracking: Value(params.enableQuantityTracking),
            repeatType: Value(params.repeatType),
            repeatInterval: Value(params.repeatInterval),
            activeDays: Value(params.activeDays),
            startHour: Value(params.startHour),
            startMinute: Value(params.startMinute),
            endHour: Value(params.endHour),
            endMinute: Value(params.endMinute),
            colorValue: Value(params.colorValue),
            enableTimeSlot: Value(params.enableTimeSlot),
            startDate: params.startDate,
            endDate: Value(params.endDate),
            sortOrder: Value(params.sortOrder),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> updateTemplate(PlanTemplate template) async {
    await _database.update(_database.planTemplates).replace(template);
  }

  Future<void> deleteTemplate(String id) async {
    await (_database.delete(_database.planTemplates)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}
