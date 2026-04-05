import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/check_in_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../domain/services/cycle_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final cycleRepositoryProvider = Provider<CycleRepository>((ref) {
  return CycleRepository(ref.watch(databaseProvider));
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.watch(databaseProvider));
});

final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  return CheckInRepository(ref.watch(databaseProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.watch(databaseProvider));
});

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getAllCategories();
});

final cycleServiceProvider = Provider<CycleService>((ref) {
  return CycleService(
    ref.watch(cycleRepositoryProvider),
    ref.watch(taskRepositoryProvider),
  );
});

final cyclesProvider = FutureProvider<List<Cycle>>((ref) async {
  final repository = ref.watch(cycleRepositoryProvider);
  return repository.getAllCycles();
});

final activeCycleProvider = FutureProvider<Cycle?>((ref) async {
  final repository = ref.watch(cycleRepositoryProvider);
  return repository.getActiveCycle();
});
