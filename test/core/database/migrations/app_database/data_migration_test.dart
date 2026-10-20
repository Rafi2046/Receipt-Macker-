import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/database/app_database.dart';

import 'generated/schema.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  test(
    'v2 to v3 keeps the business profile and adds clients and items',
    () async {
      final schema = await verifier.schemaAt(2);
      schema.rawDatabase.execute(
        'INSERT INTO business_profiles (id, name, created_at, updated_at) '
        "VALUES ('p', 'Rahman Traders', 1760000000, 1760000000)",
      );
      final db = AppDatabase(schema.newConnection());
      await verifier.migrateAndValidate(db, 3);

      final profile = await db.businessProfileDao.getPrimary();
      expect(profile?.name, 'Rahman Traders');
      expect(await db.select(db.clientsTable).get(), isEmpty);
      expect(await db.select(db.itemsTable).get(), isEmpty);
      await db.close();
    },
  );
}
