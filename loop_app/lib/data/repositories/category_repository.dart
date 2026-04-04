import 'package:drift/drift.dart';
import '../database/app_database.dart';

class CategoryRepository {
  final AppDatabase _database;

  CategoryRepository(this._database);

  Future<List<Category>> getAllCategories() async {
    return await _database.select(_database.categories).get();
  }

  Future<Category?> getCategoryById(String id) async {
    return await (_database.select(_database.categories)
          ..where((c) => c.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> insertCategory(CategoriesCompanion category) async {
    await _database.into(_database.categories).insert(category);
  }

  Future<void> updateCategory(CategoriesCompanion category) async {
    await (_database.update(_database.categories)
          ..where((c) => c.id.equals(category.id.value)))
        .write(category);
  }

  Future<void> deleteCategory(String id) async {
    await (_database.delete(_database.categories)..where((c) => c.id.equals(id))).go();
  }

  Future<int> getCategoryTaskCount(String categoryId) async {
    final count = _database.tasks.id.count();
    final query = _database.selectOnly(_database.tasks)
      ..addColumns([count])
      ..where(_database.tasks.categoryId.equals(categoryId));
    
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
