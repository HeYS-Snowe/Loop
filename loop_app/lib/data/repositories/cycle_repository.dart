import 'package:drift/drift.dart';
import '../database/app_database.dart';

class CycleRepository {
  final AppDatabase _database;

  CycleRepository(this._database);

  Future<List<Cycle>> getAllCycles() => _database.getAllCycles();

  Stream<List<Cycle>> watchAllCycles() => _database.watchAllCycles();

  Future<Cycle?> getCycleById(String id) => _database.getCycleById(id);

  Future<Cycle?> getActiveCycle() => _database.getActiveCycle();

  Future<String> insertCycle(CyclesCompanion cycle) => _database.insertCycle(cycle);

  Future<void> updateCycle(CyclesCompanion cycle) => _database.updateCycle(cycle);

  Future<void> deleteCycle(String id) => _database.deleteCycle(id);
}
