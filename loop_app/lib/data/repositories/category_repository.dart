import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../database/app_database.dart';

class CategoryRepository {
  final AppDatabase _database;
  final _uuid = const Uuid();

  CategoryRepository(this._database);

  Future<List<Category>> getAllCategories() => _database.getAllCategories();

  Stream<List<Category>> watchAllCategories() => _database.watchAllCategories();

  Future<Category> createCategory({
    required String name,
    required Color color,
    int sortOrder = 0,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    await _database.insertCategory(
      CategoriesCompanion(
        id: Value(id),
        name: Value(name),
        color: Value(color.value),
        sortOrder: Value(sortOrder),
        createdAt: Value(now),
      ),
    );

    return Category(
      id: id,
      name: name,
      color: color.value,
      sortOrder: sortOrder,
      createdAt: now,
    );
  }

  Future<void> deleteCategory(String id) => _database.deleteCategory(id);
}
