import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/constants/app_constants.dart';
import 'package:receipt_maker/core/database/app_database.dart';
import 'package:receipt_maker/core/services/share_service.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/features/backup/data/repositories/backup_repository_impl.dart';
import 'package:receipt_maker/features/backup/data/services/backup_file_picker_service.dart';

import '../../../helpers/fake_app_preferences.dart';

class MockShareService extends Mock implements ShareService {}

class MockFilePickerService extends Mock implements BackupFilePickerService {}

void main() {
  late Directory tempDocDir;
  late Directory tempCacheDir;
  late AppDatabase db;
  late FakeAppPreferences fakePrefs;
  late MockShareService mockShareService;
  late MockFilePickerService mockPickerService;
  late BackupRepositoryImpl repository;

  setUp(() async {
    tempDocDir = await Directory.systemTemp.createTemp('backup_doc_test_');
    tempCacheDir = await Directory.systemTemp.createTemp('backup_cache_test_');

    final dbFile = File(
      '${tempDocDir.path}${Platform.pathSeparator}${AppConstants.databaseFileName}',
    );
    db = AppDatabase(NativeDatabase(dbFile));
    fakePrefs = FakeAppPreferences();
    mockShareService = MockShareService();
    mockPickerService = MockFilePickerService();

    repository = BackupRepositoryImpl(
      db: db,
      prefs: fakePrefs,
      shareService: mockShareService,
      pickerService: mockPickerService,
      documentsDirectory: () async => tempDocDir,
      temporaryDirectory: () async => tempCacheDir,
    );
  });

  tearDown(() async {
    await db.close();
    if (await tempDocDir.exists()) {
      await tempDocDir.delete(recursive: true);
    }
    if (await tempCacheDir.exists()) {
      await tempCacheDir.delete(recursive: true);
    }
  });

  test(
    'createBackup exports database, manifest with counts, and media assets',
    () async {
      final now = DateTime.utc(2026, 10, 2);
      // 1. Populate database with records
      await db
          .into(db.businessProfilesTable)
          .insert(
            BusinessProfilesTableCompanion.insert(
              id: 'p1',
              name: 'My Business',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db
          .into(db.clientsTable)
          .insert(
            ClientsTableCompanion.insert(
              id: 'c1',
              name: 'Rahman Traders',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db
          .into(db.itemsTable)
          .insert(
            ItemsTableCompanion.insert(
              id: 'i1',
              name: 'Service',
              unitPriceMinor: 100000,
              currencyCode: 'BDT',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db
          .into(db.invoicesTable)
          .insert(
            InvoicesTableCompanion.insert(
              id: 'inv1',
              profileId: 'p1',
              number: 'INV-0001',
              currencyCode: 'BDT',
              issueDate: CalendarDate(2026, 10, 2).key,
              dueDate: CalendarDate(2026, 10, 9).key,
              stage: 'sent',
              totalMinor: 100000,
              createdAt: now,
              updatedAt: now,
            ),
          );

      // 2. Create test logo file
      final imagesDir = Directory('${tempDocDir.path}/images');
      await imagesDir.create(recursive: true);
      final logoFile = File('${imagesDir.path}/logo_test.png');
      await logoFile.writeAsBytes([10, 20, 30, 40]);

      // 3. Create backup
      final testTimestamp = DateTime.utc(2026, 11, 14, 15, 30, 45);
      final zipFile = await repository.createBackup(timestamp: testTimestamp);

      expect(await zipFile.exists(), isTrue);
      expect(zipFile.path, contains('quickbill_backup_20261114_153045.zip'));
      expect(fakePrefs.lastBackupMillis, testTimestamp.millisecondsSinceEpoch);

      // 4. Validate backup
      final zipBytes = await zipFile.readAsBytes();
      final manifest = await repository.validateBackup(zipBytes);

      expect(manifest.version, 1);
      expect(manifest.schemaVersion, 5);
      expect(manifest.clientCount, 1);
      expect(manifest.itemCount, 1);
      expect(manifest.invoiceCount, 1);
      expect(manifest.mediaFiles, contains('images/logo_test.png'));
    },
  );

  test('restoreBackup overwrites database and restores media files', () async {
    final now = DateTime.utc(2026, 10, 2);
    // 1. Setup backup data in first database
    await db
        .into(db.clientsTable)
        .insert(
          ClientsTableCompanion.insert(
            id: 'orig1',
            name: 'Original Client',
            createdAt: now,
            updatedAt: now,
          ),
        );
    final imagesDir = Directory('${tempDocDir.path}/images');
    await imagesDir.create(recursive: true);
    final logoFile = File('${imagesDir.path}/restored_logo.png');
    await logoFile.writeAsBytes([99, 88, 77]);

    final zipFile = await repository.createBackup();
    final zipBytes = await zipFile.readAsBytes();

    // 2. Change original data to simulate different state before restore
    await db
        .into(db.clientsTable)
        .insert(
          ClientsTableCompanion.insert(
            id: 'different2',
            name: 'Different Client',
            createdAt: now,
            updatedAt: now,
          ),
        );
    // Delete the logo
    await logoFile.delete();

    // 3. Perform restore
    await repository.restoreBackup(zipBytes);

    // Reopen db to check restored state
    final restoredDbFile = File(
      '${tempDocDir.path}${Platform.pathSeparator}${AppConstants.databaseFileName}',
    );
    final restoredDb = AppDatabase(NativeDatabase(restoredDbFile));

    final clients = await restoredDb.select(restoredDb.clientsTable).get();
    expect(clients.length, 1);
    expect(clients.first.name, 'Original Client');

    // Verify logo was restored
    expect(await logoFile.exists(), isTrue);
    expect(await logoFile.readAsBytes(), [99, 88, 77]);

    await restoredDb.close();
  });

  test('shareBackup delegates to ShareService', () async {
    final file = File('${tempCacheDir.path}/test.zip');
    await file.writeAsBytes([1, 2, 3]);

    when(
      () => mockShareService.shareFile(
        file.path,
        mimeType: 'application/zip',
        subject: any(named: 'subject'),
      ),
    ).thenAnswer((_) async => true);

    final success = await repository.shareBackup(file);
    expect(success, isTrue);
    verify(
      () => mockShareService.shareFile(
        file.path,
        mimeType: 'application/zip',
        subject: 'test.zip',
      ),
    ).called(1);
  });

  test('pickBackupFile delegates to BackupFilePickerService', () async {
    when(() => mockPickerService.pickBackupZip())
        .thenAnswer((_) async => Uint8List.fromList([1, 2, 3]));

    final result = await repository.pickBackupFile();
    expect(result, [1, 2, 3]);
    verify(() => mockPickerService.pickBackupZip()).called(1);
  });
}
