import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';

part 'app_database.g.dart';

/// The single SQLite database. Tables and DAOs are added per feature (M2+).
///
/// Every schema change: bump [schemaVersion], add a step in [migration],
/// add a migration test.
@DriftDatabase()
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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
