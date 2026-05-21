import 'package:drift/drift.dart';
import 'package:loop_app/data/database/app_database.dart';
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
    bool enableTimeSlot = true,
    bool isActive = true,
    required DateTime startDate,
    DateTime? endDate,
    int sortOrder = 0,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await _database.into(_database.planTemplates).insert(
          PlanTemplatesCompanion.insert(
            id: id,
            name: name,
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
            enableTimeSlot: Value(enableTimeSlot),
            startDate: startDate,
            endDate: Value(endDate),
            sortOrder: Value(sortOrder),
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
