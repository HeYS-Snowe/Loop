import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final response = await WasmDatabase.open(
      databaseName: 'loop_app',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    if (response.missingFeatures.isNotEmpty) {
      print('Using IndexedDB based implementation');
    }

    return response.resolvedExecutor;
  });
}
