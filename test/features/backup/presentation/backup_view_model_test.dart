import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/features/backup/domain/models/backup_manifest.dart';
import 'package:receipt_maker/features/backup/domain/models/backup_validation_exception.dart';
import 'package:receipt_maker/features/backup/presentation/view_models/backup_view_model.dart';
import 'package:receipt_maker/features/backup/providers.dart';

import '../../../helpers/mock_repositories.dart';

void main() {
  late MockBackupRepository mockRepo;
  late ProviderContainer container;

  final sampleManifest = BackupManifest(
    version: 1,
    schemaVersion: 5,
    createdAt: DateTime.utc(2026, 11, 14, 20),
    invoiceCount: 10,
    clientCount: 4,
    itemCount: 8,
    paymentCount: 3,
  );

  setUp(() {
    mockRepo = MockBackupRepository();
    container = ProviderContainer(
      overrides: [backupRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() => container.dispose());

  test('initial state loads lastBackupDate', () {
    final now = DateTime.utc(2026, 11, 14);
    when(() => mockRepo.getLastBackupDate()).thenReturn(now);

    final state = container.read(backupViewModelProvider);
    expect(state.lastBackupDate, now);
    expect(state.isCreatingBackup, isFalse);
    expect(state.isRestoring, isFalse);
  });

  test('createBackup creates, shares, and updates last backup date', () async {
    final backupFile = File('/tmp/test_backup.zip');
    final now = DateTime.utc(2026, 11, 14, 21);

    when(() => mockRepo.getLastBackupDate()).thenReturn(null);
    when(() => mockRepo.createBackup()).thenAnswer((_) async => backupFile);
    when(() => mockRepo.shareBackup(backupFile)).thenAnswer((_) async => true);

    final vm = container.read(backupViewModelProvider.notifier);
    when(() => mockRepo.getLastBackupDate()).thenReturn(now);

    await vm.createBackup();

    final state = container.read(backupViewModelProvider);
    expect(state.isCreatingBackup, isFalse);
    expect(state.lastBackupDate, now);
    expect(state.successMessage, 'backupExportSuccess');
    expect(state.errorMessage, isNull);
  });

  test('createBackup sets errorMessage on failure', () async {
    when(() => mockRepo.getLastBackupDate()).thenReturn(null);
    when(() => mockRepo.createBackup())
        .thenThrow(const FileSystemException('Write error'));

    final vm = container.read(backupViewModelProvider.notifier);
    await vm.createBackup();

    final state = container.read(backupViewModelProvider);
    expect(state.isCreatingBackup, isFalse);
    expect(state.errorMessage, contains('Write error'));
  });

  test(
    'pickAndValidateBackup sets pending restore manifest and bytes',
    () async {
      final zipBytes = Uint8List.fromList([1, 2, 3]);
      when(() => mockRepo.getLastBackupDate()).thenReturn(null);
      when(() => mockRepo.pickBackupFile()).thenAnswer((_) async => zipBytes);
      when(() => mockRepo.validateBackup(zipBytes))
          .thenAnswer((_) async => sampleManifest);

      final vm = container.read(backupViewModelProvider.notifier);
      await vm.pickAndValidateBackup();

      final state = container.read(backupViewModelProvider);
      expect(state.pendingRestoreManifest, sampleManifest);
      expect(state.pendingRestoreBytes, zipBytes);
      expect(state.errorMessage, isNull);
    },
  );

  test(
    'pickAndValidateBackup sets errorMessage on validation failure',
    () async {
      final zipBytes = Uint8List.fromList([1, 2, 3]);
      when(() => mockRepo.getLastBackupDate()).thenReturn(null);
      when(() => mockRepo.pickBackupFile()).thenAnswer((_) async => zipBytes);
      when(() => mockRepo.validateBackup(zipBytes))
          .thenThrow(const BackupValidationException('Invalid header'));

      final vm = container.read(backupViewModelProvider.notifier);
      await vm.pickAndValidateBackup();

      final state = container.read(backupViewModelProvider);
      expect(state.pendingRestoreManifest, isNull);
      expect(state.pendingRestoreBytes, isNull);
      expect(state.errorMessage, 'Invalid header');
    },
  );

  test(
    'confirmRestore calls restoreBackup, invalidates db, and clears pending',
    () async {
      final zipBytes = Uint8List.fromList([1, 2, 3]);
      when(() => mockRepo.getLastBackupDate()).thenReturn(null);
      when(() => mockRepo.pickBackupFile()).thenAnswer((_) async => zipBytes);
      when(() => mockRepo.validateBackup(zipBytes))
          .thenAnswer((_) async => sampleManifest);
      when(() => mockRepo.restoreBackup(zipBytes)).thenAnswer((_) async {});

      final vm = container.read(backupViewModelProvider.notifier);
      await vm.pickAndValidateBackup();

      final success = await vm.confirmRestore();
      expect(success, isTrue);
      verify(() => mockRepo.restoreBackup(zipBytes)).called(1);

      final state = container.read(backupViewModelProvider);
      expect(state.isRestoring, isFalse);
      expect(state.pendingRestoreManifest, isNull);
      expect(state.pendingRestoreBytes, isNull);
      expect(state.successMessage, 'backupRestoreSuccess');
    },
  );

  test('cancelPendingRestore resets pending manifest and bytes', () async {
    final zipBytes = Uint8List.fromList([1, 2, 3]);
    when(() => mockRepo.getLastBackupDate()).thenReturn(null);
    when(() => mockRepo.pickBackupFile()).thenAnswer((_) async => zipBytes);
    when(() => mockRepo.validateBackup(zipBytes))
        .thenAnswer((_) async => sampleManifest);

    final vm = container.read(backupViewModelProvider.notifier);
    await vm.pickAndValidateBackup();
    expect(
      container.read(backupViewModelProvider).pendingRestoreManifest,
      isNotNull,
    );

    vm.cancelPendingRestore();
    expect(
      container.read(backupViewModelProvider).pendingRestoreManifest,
      isNull,
    );
    expect(container.read(backupViewModelProvider).pendingRestoreBytes, isNull);
  });
}
