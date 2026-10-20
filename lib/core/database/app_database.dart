import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';
import 'app_database.steps.dart';
import 'daos/business_profile_dao.dart';
import 'daos/client_dao.dart';
import 'daos/item_dao.dart';
import 'tables/business_profiles_table.dart';
import 'tables/clients_table.dart';
import 'tables/items_table.dart';

part 'app_database.g.dart';

/// The single SQLite database. Tables and DAOs are added per feature (M2+).
///
/// Every schema change: bump [schemaVersion], add a step in [migration],
/// add a migration test.
@DriftDatabase(
  tables: [BusinessProfilesTable, ClientsTable, ItemsTable],
  daos: [BusinessProfileDao, ClientDao, ItemDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Opens the on-device database file on a background isolate.
  factory AppDatabase.open() => AppDatabase(
    LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}${Platform.pathSeparator}${AppConstants.databaseFileName}',
      );
      return NativeDatabase.createInBackground(file);
    }),
  );

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        await m.createTable(schema.businessProfiles);
      },
      from2To3: (m, schema) async {
        await m.createTable(schema.clients);
        await m.createTable(schema.items);
      },
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
