import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../../shared/extensions/date_extensions.dart';

class CheckInRepository {
  final AppDatabase _database;
  final _uuid = const Uuid();

  CheckInRepository(this._database);

  Future<List<CheckInRecord>> getAllCheckIns() => _database.getAllCheckIns();

  Stream<List<CheckInRecord>> watchAllCheckIns() => _database.watchAllCheckIns();

  Future<CheckInRecord?> getCheckInByDate(DateTime date) =>
      _database.getCheckInByDate(date);

  Future<CheckInRecord?> getLastCheckIn() => _database.getLastCheckIn();

  Future<bool> hasCheckedInToday() async {
    final today = DateTime.now();
    final record = await getCheckInByDate(today);
    return record != null;
  }

  Future<CheckInRecord> checkIn({String? note}) async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    final yesterdayRecord = await getCheckInByDate(yesterday);
    final lastRecord = await getLastCheckIn();

    int streakCount = 1;
    if (yesterdayRecord != null) {
      streakCount = (lastRecord?.streakCount ?? 0) + 1;
    }

    final id = _uuid.v4();

    await _database.insertCheckIn(
      CheckInRecordsCompanion(
        id: Value(id),
        date: Value(now),
        streakCount: Value(streakCount),
        note: Value(note),
        createdAt: Value(now),
      ),
    );

    return CheckInRecord(
      id: id,
      date: now,
      streakCount: streakCount,
      note: note,
      createdAt: now,
    );
  }

  Future<int> getCurrentStreak() async {
    final lastRecord = await getLastCheckIn();
    if (lastRecord == null) return 0;

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    if (!lastRecord.date.isSameDay(today) &&
        !lastRecord.date.isSameDay(yesterday)) {
      return 0;
    }

    return lastRecord.streakCount;
  }
}
