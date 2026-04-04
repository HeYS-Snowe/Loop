import 'package:drift/drift.dart';
import '../database/app_database.dart';

class CheckInRepository {
  final AppDatabase _database;

  CheckInRepository(this._database);

  Future<List<CheckInRecord>> getAllRecords() {
    return _database.getCheckInRecords();
  }

  Future<CheckInRecord?> getRecordByDate(DateTime date) {
    return _database.getCheckInRecordByDate(date);
  }

  Future<CheckInRecord?> getLastRecord() {
    return _database.getLastCheckInRecord();
  }

  Future<void> insertRecord(CheckInRecordsCompanion record) async {
    await _database.insertCheckInRecord(record);
  }
}
