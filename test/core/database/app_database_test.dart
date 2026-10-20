import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('opens at schema version 1 with foreign keys on', () async {
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    final fk = await db.customSelect('PRAGMA foreign_keys').getSingle();

    expect(db.schemaVersion, 1);
    expect(version.read<int>('user_version'), 1);
    expect(fk.read<int>('foreign_keys'), 1);
  });
}
