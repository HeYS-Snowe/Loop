import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

class CycleRepository {
  final AppDatabase _database;
  final _uuid = const Uuid();

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
    final now = DateTime.now();
    final id = _uuid.v4();

    await _database.insertCycle(
      CyclesCompanion(
        id: Value(id),
        name: Value(name),
        description: Value(description),
        startDate: Value(startDate),
        endDate: Value(endDate),
        status: const Value('active'),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    return Cycle(
      id: id,
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      status: 'active',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<void> updateCycle(Cycle cycle) async {
    await _database.updateCycle(
      CyclesCompanion(
        id: Value(cycle.id),
        name: Value(cycle.name),
        description: Value(cycle.description),
        startDate: Value(cycle.startDate),
        endDate: Value(cycle.endDate),
        status: Value(cycle.status),
        createdAt: Value(cycle.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> completeCycle(String cycleId) async {
    await _database.updateCycle(
      CyclesCompanion(
        id: Value(cycleId),
        status: const Value('completed'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteCycle(String id) => _database.deleteCycle(id);
}
