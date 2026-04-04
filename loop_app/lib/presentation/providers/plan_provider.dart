import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop/data/database/app_database.dart';
import 'package:loop/data/repositories/plan_template_repository.dart';
import 'package:loop/data/repositories/plan_instance_repository.dart';
import 'package:loop/presentation/providers/cycle_provider.dart';

final planTemplateRepositoryProvider = Provider<PlanTemplateRepository>((ref) {
  return PlanTemplateRepository(ref.watch(databaseProvider));
});

final planInstanceRepositoryProvider = Provider<PlanInstanceRepository>((ref) {
  return PlanInstanceRepository(ref.watch(databaseProvider));
});

final allPlanTemplatesProvider = FutureProvider<List<PlanTemplate>>((ref) {
  final repository = ref.watch(planTemplateRepositoryProvider);
  return repository.getAllTemplates();
});

final planTemplateDetailProvider =
    FutureProvider.family<PlanTemplate?, String>((ref, id) {
  final repository = ref.watch(planTemplateRepositoryProvider);
  return repository.getTemplateById(id);
});

final planInstancesByDateProvider =
    FutureProvider.family<List<PlanInstance>, DateTime>((ref, date) async {
  final instanceRepo = ref.watch(planInstanceRepositoryProvider);
  await instanceRepo.ensureInstancesForDate(date);
  return instanceRepo.getInstancesByDate(date);
});

final planInstancesByDateRangeProvider =
    FutureProvider.family<List<PlanInstance>, ({DateTime start, DateTime end})>(
        (ref, params) {
  final repository = ref.watch(planInstanceRepositoryProvider);
  return repository.getInstancesByDateRange(params.start, params.end);
});

final planTemplateNotifierProvider = StateNotifierProvider<PlanTemplateNotifier,
    AsyncValue<List<PlanTemplate>>>((ref) {
  return PlanTemplateNotifier(ref.watch(planTemplateRepositoryProvider));
});

class PlanTemplateNotifier
    extends StateNotifier<AsyncValue<List<PlanTemplate>>> {
  final PlanTemplateRepository _repository;

  PlanTemplateNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadTemplates() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getAllTemplates());
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
    required DateTime startDate,
    DateTime? endDate,
    int sortOrder = 0,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.createTemplate(
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
        startDate: startDate,
        endDate: endDate,
        sortOrder: sortOrder,
      );
      return _repository.getAllTemplates();
    });
  }

  Future<void> updateTemplate(PlanTemplate template) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateTemplate(template);
      return _repository.getAllTemplates();
    });
  }

  Future<void> deleteTemplate(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteTemplate(id);
      return _repository.getAllTemplates();
    });
  }
}

final planInstanceNotifierProvider =
    StateNotifierProvider<PlanInstanceNotifier, AsyncValue<List<PlanInstance>>>(
        (ref) {
  return PlanInstanceNotifier(
    ref.watch(planInstanceRepositoryProvider),
  );
});

class PlanInstanceNotifier
    extends StateNotifier<AsyncValue<List<PlanInstance>>> {
  final PlanInstanceRepository _instanceRepo;
  DateTime _currentDate = DateTime.now();

  PlanInstanceNotifier(this._instanceRepo)
      : super(const AsyncValue.loading());

  DateTime get currentDate => _currentDate;

  Future<void> loadForDate(DateTime date) async {
    _currentDate = date;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _instanceRepo.ensureInstancesForDate(date);
      return _instanceRepo.getInstancesByDate(date);
    });
  }

  Future<void> updateCompletedAmount(String instanceId, int amount) async {
    state = await AsyncValue.guard(() async {
      final instances = await _instanceRepo.getInstancesByDate(_currentDate);
      final instance = instances.firstWhere(
        (i) => i.id == instanceId,
        orElse: () => throw StateError('Instance not found: $instanceId'),
      );
      final targetAmount = instance.targetAmount;
      final clampedAmount = amount.clamp(0, targetAmount);

      await _instanceRepo.updateInstance(PlanInstance(
        id: instance.id,
        planTemplateId: instance.planTemplateId,
        date: instance.date,
        targetAmount: instance.targetAmount,
        completedAmount: clampedAmount,
        isCompleted: clampedAmount >= targetAmount && targetAmount > 0,
        note: instance.note,
        createdAt: instance.createdAt,
        updatedAt: DateTime.now(),
      ));

      await _instanceRepo.ensureInstancesForDate(_currentDate);
      return _instanceRepo.getInstancesByDate(_currentDate);
    });
  }

  Future<void> toggleComplete(String instanceId) async {
    state = await AsyncValue.guard(() async {
      final instances = await _instanceRepo.getInstancesByDate(_currentDate);
      final instance = instances.firstWhere(
        (i) => i.id == instanceId,
        orElse: () => throw StateError('Instance not found: $instanceId'),
      );

      if (instance.isCompleted) {
        await _instanceRepo.uncompleteInstance(instanceId);
      } else {
        await _instanceRepo.completeInstance(instanceId);
      }

      await _instanceRepo.ensureInstancesForDate(_currentDate);
      return _instanceRepo.getInstancesByDate(_currentDate);
    });
  }
}
