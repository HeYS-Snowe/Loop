import 'package:drift/drift.dart' hide Column;
import 'package:loop_app/data/database/app_database.dart';

class CheckInRecord {
  final String id;
  final DateTime date;
  final int streakCount;
  final String? note;
  final DateTime createdAt;

  CheckInRecord({
    required this.id,
    required this.date,
    required this.streakCount,
    this.note,
    required this.createdAt,
  });

  factory CheckInRecord.fromDrift(CheckInRecord driftRecord) {
    return CheckInRecord(
      id: driftRecord.id,
      date: driftRecord.date,
      streakCount: driftRecord.streakCount,
      note: driftRecord.note,
      createdAt: driftRecord.createdAt,
    );
  }

  CheckInRecordsCompanion toCompanion() {
    return CheckInRecordsCompanion(
      id: Value(id),
      date: Value(date),
      streakCount: Value(streakCount),
      note: Value(note),
      createdAt: Value(createdAt),
    );
  }
}
