import 'package:drift/drift.dart';
import '../database/app_database.dart';

extension CheckInRecordX on CheckInRecord {
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
