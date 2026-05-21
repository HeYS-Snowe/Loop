import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/plan_template_repository.dart';
import '../../data/repositories/plan_instance_repository.dart';
import 'cycle_provider.dart';

enum PlanEditScope {
  thisOnly,
  future,
  past,
  all,
}

final planTemplateRepositoryProvider = Provider<PlanTemplateRepository>((ref) {
  return PlanTemplateRepository(ref.watch(databaseProvider));
});

final planInstanceRepositoryProvider = Provider<PlanInstanceRepository>((ref) {
  return PlanInstanceRepository(ref.watch(databaseProvider));
});

final planTemplatesProvider = FutureProvider<List<PlanTemplate>>((ref) async {
  final repository = ref.watch(planTemplateRepositoryProvider);
  return repository.getAllTemplates();
});

final allPlanTemplatesProvider = planTemplatesProvider;

final planInstancesByDateProvider =
    FutureProvider.family<List<PlanInstance>, DateTime>((ref, date) async {
  final repository = ref.watch(planInstanceRepositoryProvider);
  await repository.ensureInstancesForDate(date);
  return repository.getInstancesByDate(date);
});

final planInstancesByDateRangeProvider = FutureProvider.family<
    List<PlanInstance>,
    ({DateTime start, DateTime end})>((ref, params) async {
  final repository = ref.watch(planInstanceRepositoryProvider);
  return repository.getInstancesByDateRange(params.start, params.end);
});

class PlanTemplateNotifier extends AsyncNotifier<List<PlanTemplate>> {
  @override
  Future<List<PlanTemplate>> build() async {
    final repository = ref.watch(planTemplateRepositoryProvider);
    return repository.getAllTemplates();
  }

  PlanTemplateRepository get _templateRepo =>
      ref.read(planTemplateRepositoryProvider);

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
    await _templateRepo.createTemplate(
      name: name,
      description: description,
      categoryId: categoryId,
      dailyTargetAmount: dailyTargetAmount,
      unit: unit,
      enableQuantityTracking: enableQuantityTracking,
      repeatType: repeatType,
      repeatInterval: repeatInterval,
      activeDays: activeDays,
      startHour: startHour,
      startMinute: startMinute,
      endHour: endHour,
      endMinute: endMinute,
      colorValue: colorValue,
      enableTimeSlot: enableTimeSlot,
      isActive: isActive,
      startDate: startDate,
      endDate: endDate,
      sortOrder: sortOrder,
    );
    ref.invalidateSelf();
  }

  Future<void> updateTemplate(PlanTemplate template) async {
    await _templateRepo.updateTemplate(template);
    ref.invalidateSelf();
  }

  Future<void> updateTemplateWithScope({
    required PlanTemplate template,
    required PlanEditScope scope,
    required DateTime currentDate,
  }) async {
    await _templateRepo.updateTemplate(template);

    final instanceRepo = ref.read(planInstanceRepositoryProvider);
    switch (scope) {
      case PlanEditScope.thisOnly:
        break;
      case PlanEditScope.future:
        await instanceRepo.updateInstancesByTemplateExcludeDate(
          templateId: template.id,
          excludeDate: currentDate,
          targetAmount: template.dailyTargetAmount,
        );
        break;
      case PlanEditScope.past:
        await instanceRepo.updateInstancesByTemplateBeforeDate(
          templateId: template.id,
          beforeDate: currentDate,
          targetAmount: template.dailyTargetAmount,
        );
        break;
      case PlanEditScope.all:
        await instanceRepo.updateAllInstancesByTemplate(
          templateId: template.id,
          targetAmount: template.dailyTargetAmount,
        );
        break;
    }

    ref.invalidateSelf();
  }

  Future<void> deleteTemplate(String templateId) async {
    await _templateRepo.deleteTemplate(templateId);
    ref.invalidateSelf();
  }
}

final planTemplateNotifierProvider =
    AsyncNotifierProvider<PlanTemplateNotifier, List<PlanTemplate>>(
  PlanTemplateNotifier.new,
);

class PlanInstanceNotifier extends AsyncNotifier<List<PlanInstance>> {
  DateTime? _currentDate;

  @override
  Future<List<PlanInstance>> build() async {
    if (_currentDate == null) return [];
    final repository = ref.watch(planInstanceRepositoryProvider);
    await repository.ensureInstancesForDate(_currentDate!);
    return repository.getInstancesByDate(_currentDate!);
  }

  PlanInstanceRepository get _instanceRepo =>
      ref.read(planInstanceRepositoryProvider);

  void loadForDate(DateTime date) {
    _currentDate = date;
    ref.invalidateSelf();
  }

  Future<void> toggleComplete(String instanceId) async {
    final current = state.value ?? [];
    final instance = current.firstWhere((i) => i.id == instanceId);
    if (instance.isCompleted) {
      await _instanceRepo.uncompleteInstance(instanceId);
    } else {
      await _instanceRepo.completeInstance(instanceId);
    }
    ref.invalidateSelf();
  }

  Future<void> updateCompletedAmount(String instanceId, int amount) async {
    final current = state.value ?? [];
    final instance = current.firstWhere((i) => i.id == instanceId);
    await _instanceRepo.updateInstance(
      instance.copyWith(completedAmount: amount),
    );
    ref.invalidateSelf();
  }

  Future<List<PlanInstance>> getInstancesForDate(DateTime date) async {
    await _instanceRepo.ensureInstancesForDate(date);
    return _instanceRepo.getInstancesByDate(date);
  }
}

final planInstanceNotifierProvider =
    AsyncNotifierProvider<PlanInstanceNotifier, List<PlanInstance>>(
  PlanInstanceNotifier.new,
);
