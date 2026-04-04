import 'package:drift/drift.dart';
import '../database/app_database.dart';

class CycleRepository {
  final AppDatabase _database;

  CycleRepository(this._database);

  Future<List<Cycle>> getAllCycles() => _database.getAllCycles();

  Stream<List<Cycle>> watchAllCycles() => _database.watchAllCycles();

  Future<Cycle?> getCycleById(String id) => _database.getCycleById(id);

  Future<Cycle?> getActiveCycle() => _database.getActiveCycle();

  Future<Cycle> createCycle({
    required String name,
    String? description,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final id = _generateId();
    await _database.insertCycle(CyclesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      startDate: Value(startDate),
      endDate: Value(endDate),
      status: const Value('active'),
      isActive: const Value(true),
    ));
    final cycle = await _database.getCycleById(id);
    return cycle!;
  }

  Future<void> updateCycle(Cycle cycle) async {
    await _database.updateCycle(CyclesCompanion(
      id: Value(cycle.id),
      name: Value(cycle.name),
      description: Value(cycle.description),
      startDate: Value(cycle.startDate),
      endDate: Value(cycle.endDate),
      status: Value(cycle.status),
      isActive: Value(cycle.isActive),
      createdAt: Value(cycle.createdAt),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> completeCycle(String cycleId) async {
    await _database.updateCycle(CyclesCompanion(
      id: Value(cycleId),
      status: const Value('completed'),
      isActive: const Value(false),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> deleteCycle(String id) => _database.deleteCycle(id);

  String _generateId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return '${timestamp.toRadixString(16).padLeft(8, '0')}-'
        '${(timestamp ^ 0xFFFF).toRadixString(16).padLeft(4, '0')}-'
        '4${(timestamp & 0x0FFF).toRadixString(16).padLeft(3, '0')}-'
        '${(timestamp & 0x3FFF | 0x8000).toRadixString(16).padLeft(4, '0')}-'
        '${(timestamp ^ 0xFFFFFFFF).toRadixString(16).padLeft(8, '0')}'
        '${timestamp.toRadixString(16).padLeft(4, '0')}';
  }
}
