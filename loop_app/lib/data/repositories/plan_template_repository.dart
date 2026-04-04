import 'package:drift/drift.dart';
import '../database/app_database.dart';

class PlanTemplateRepository {
  final AppDatabase _database;

  PlanTemplateRepository(this._database);

  Future<List<PlanTemplate>> getAllTemplates() =>
      _database.getAllPlanTemplates();

  Future<PlanTemplate?> getTemplateById(String id) =>
      _database.getPlanTemplateById(id);

  Future<void> createTemplate({
    required String name,
    String? description,
    String? categoryId,
    int dailyTargetAmount = 0,
    String? unit,
    bool enableQuantityTracking = true,
    String repeatType = 'none',
    int repeatInterval = 1,
    String activeDays = '1,2,3,4,5,6,7',
    int startHour = 8,
    int startMinute = 0,
    int endHour = 9,
    int endMinute = 0,
    int colorValue = 0xFF2196F3,
    required DateTime startDate,
    DateTime? endDate,
    int sortOrder = 0,
  }) async {
    await _database.insertPlanTemplate(PlanTemplatesCompanion(
      id: Value(Uuid().v4()),
      name: Value(name),
      description: Value(description),
      categoryId: Value(categoryId),
      dailyTargetAmount: Value(dailyTargetAmount),
      unit: Value(unit),
      enableQuantityTracking: Value(enableQuantityTracking),
      repeatType: Value(repeatType),
      repeatInterval: Value(repeatInterval),
      activeDays: Value(activeDays),
      startHour: Value(startHour),
      startMinute: Value(startMinute),
      endHour: Value(endHour),
      endMinute: Value(endMinute),
      colorValue: Value(colorValue),
      startDate: Value(startDate),
      endDate: Value(endDate),
      isActive: const Value(true),
      sortOrder: Value(sortOrder),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> updateTemplate(PlanTemplate template) async {
    await _database.updatePlanTemplate(PlanTemplatesCompanion(
      id: Value(template.id),
      name: Value(template.name),
      description: Value(template.description),
      categoryId: Value(template.categoryId),
      dailyTargetAmount: Value(template.dailyTargetAmount),
      unit: Value(template.unit),
      enableQuantityTracking: Value(template.enableQuantityTracking),
      repeatType: Value(template.repeatType),
      repeatInterval: Value(template.repeatInterval),
      activeDays: Value(template.activeDays),
      startHour: Value(template.startHour),
      startMinute: Value(template.startMinute),
      endHour: Value(template.endHour),
      endMinute: Value(template.endMinute),
      colorValue: Value(template.colorValue),
      startDate: Value(template.startDate),
      endDate: Value(template.endDate),
      isActive: Value(template.isActive),
      sortOrder: Value(template.sortOrder),
      createdAt: Value(template.createdAt),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> deleteTemplate(String id) async {
    await _database.deletePlanTemplate(id);
  }
}

class Uuid {
  String v4() {
    final random = DateTime.now().microsecondsSinceEpoch;
    return '${random.toRadixString(16).padLeft(8, '0')}-'
        '${(random ^ 0xFFFF).toRadixString(16).padLeft(4, '0')}-'
        '4${(random & 0x0FFF).toRadixString(16).padLeft(3, '0')}-'
        '${(random & 0x3FFF | 0x8000).toRadixString(16).padLeft(4, '0')}-'
        '${(random ^ 0xFFFFFFFF).toRadixString(16).padLeft(8, '0')}'
        '${random.toRadixString(16).padLeft(4, '0')}';
  }
}
