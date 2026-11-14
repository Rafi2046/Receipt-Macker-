import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/features/backup/domain/models/backup_manifest.dart';
import 'package:receipt_maker/features/backup/presentation/views/backup_view.dart';
import 'package:receipt_maker/features/backup/providers.dart';

import '../../../helpers/mock_repositories.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late MockBackupRepository mockRepo;

  final sampleManifest = BackupManifest(
    version: 1,
    schemaVersion: 5,
    createdAt: DateTime.utc(2026, 11, 14, 20),
    invoiceCount: 10,
    clientCount: 4,
    itemCount: 8,
    paymentCount: 3,
  );

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    mockRepo = MockBackupRepository();
    when(() => mockRepo.getLastBackupDate()).thenReturn(null);
  });

  testWidgets('renders BackupView in English with cards and buttons', (
    tester,
  ) async {
    when(() => mockRepo.getLastBackupDate())
        .thenReturn(DateTime.utc(2026, 11, 14, 10));

    await tester.pumpApp(
      const BackupView(),
      overrides: [backupRepositoryProvider.overrideWithValue(mockRepo)],
    );

    expect(find.text('Backup & restore'), findsOneWidget);
    expect(find.text('Export backup'), findsWidgets);
    expect(find.text('Restore from backup'), findsOneWidget);
    expect(find.text('Select backup file'), findsOneWidget);
    expect(find.textContaining('Last backup:'), findsOneWidget);
  });

  testWidgets('renders BackupView in Bangla', (tester) async {
    await tester.pumpApp(
      const BackupView(),
      language: 'bn',
      overrides: [backupRepositoryProvider.overrideWithValue(mockRepo)],
    );

    expect(find.text('ব্যাকআপ ও রিস্টোর'), findsOneWidget);
    expect(find.text('ব্যাকআপ এক্সপোর্ট'), findsOneWidget);
    expect(find.text('ব্যাকআপ থেকে রিস্টোর'), findsOneWidget);
    expect(find.text('ব্যাকআপ এক্সপোর্ট করুন'), findsOneWidget);
    expect(find.text('ব্যাকআপ ফাইল নির্বাচন করুন'), findsOneWidget);
  });

  testWidgets('tapping Export backup creates and shares backup', (
    tester,
  ) async {
    final file = File('/tmp/test_backup.zip');
    when(() => mockRepo.createBackup()).thenAnswer((_) async => file);
    when(() => mockRepo.shareBackup(file)).thenAnswer((_) async => true);

    await tester.pumpApp(
      const BackupView(),
      overrides: [backupRepositoryProvider.overrideWithValue(mockRepo)],
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Export backup'));
    await tester.pumpAndSettle();

    verify(() => mockRepo.createBackup()).called(1);
    verify(() => mockRepo.shareBackup(file)).called(1);
  });

  testWidgets(
    'picking backup shows confirmation dialog with metadata and allows restore',
    (tester) async {
      final zipBytes = Uint8List.fromList([1, 2, 3]);
      when(() => mockRepo.pickBackupFile()).thenAnswer((_) async => zipBytes);
      when(() => mockRepo.validateBackup(zipBytes))
          .thenAnswer((_) async => sampleManifest);
      when(() => mockRepo.restoreBackup(zipBytes)).thenAnswer((_) async {});

      await tester.pumpApp(
        const BackupView(),
        overrides: [backupRepositoryProvider.overrideWithValue(mockRepo)],
      );

      await tester.tap(find.text('Select backup file'));
      await tester.pumpAndSettle();

      // Verify confirmation dialog appeared
      expect(find.text('Restore data?'), findsOneWidget);
      expect(find.textContaining('Invoices: 10'), findsOneWidget);
      expect(find.textContaining('Clients: 4'), findsOneWidget);
      expect(find.textContaining('Items: 8'), findsOneWidget);
      expect(find.textContaining('Schema version: 5'), findsOneWidget);
      expect(find.text('Restore data'), findsWidgets);

      // Tap Restore data in the dialog
      await tester.tap(find.widgetWithText(FilledButton, 'Restore data'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.restoreBackup(zipBytes)).called(1);
    },
  );

  testWidgets('cancelling confirmation dialog does not restore', (
    tester,
  ) async {
    final zipBytes = Uint8List.fromList([1, 2, 3]);
    when(() => mockRepo.pickBackupFile()).thenAnswer((_) async => zipBytes);
    when(() => mockRepo.validateBackup(zipBytes))
        .thenAnswer((_) async => sampleManifest);

    await tester.pumpApp(
      const BackupView(),
      overrides: [backupRepositoryProvider.overrideWithValue(mockRepo)],
    );

    await tester.tap(find.text('Select backup file'));
    await tester.pumpAndSettle();

    expect(find.text('Restore data?'), findsOneWidget);

    // Tap Cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Restore data?'), findsNothing);
    verifyNever(() => mockRepo.restoreBackup(any()));
  });
}
