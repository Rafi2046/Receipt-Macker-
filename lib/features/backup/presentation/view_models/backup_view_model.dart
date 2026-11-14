import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database_provider.dart';
import '../../domain/models/backup_validation_exception.dart';
import '../../providers.dart';
import 'backup_state.dart';

part 'backup_view_model.g.dart';

@riverpod
class BackupViewModel extends _$BackupViewModel {
  @override
  BackupState build() {
    final repo = ref.watch(backupRepositoryProvider);
    return BackupState(lastBackupDate: repo.getLastBackupDate());
  }

  Future<void> createBackup() async {
    state = state.copyWith(
      isCreatingBackup: true,
      errorMessage: null,
      successMessage: null,
    );
    try {
      final repo = ref.read(backupRepositoryProvider);
      final file = await repo.createBackup();
      await repo.shareBackup(file);
      state = state.copyWith(
        isCreatingBackup: false,
        lastBackupDate: repo.getLastBackupDate(),
        successMessage: 'backupExportSuccess',
      );
    } catch (e) {
      state = state.copyWith(
        isCreatingBackup: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> pickAndValidateBackup() async {
    state = state.copyWith(errorMessage: null, successMessage: null);
    try {
      final repo = ref.read(backupRepositoryProvider);
      final bytes = await repo.pickBackupFile();
      if (bytes == null) return; // User cancelled picker.

      final manifest = await repo.validateBackup(bytes);
      state = state.copyWith(
        pendingRestoreManifest: manifest,
        pendingRestoreBytes: bytes,
      );
    } on BackupValidationException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<bool> confirmRestore() async {
    final bytes = state.pendingRestoreBytes;
    if (bytes == null) return false;

    state = state.copyWith(
      isRestoring: true,
      errorMessage: null,
      successMessage: null,
    );
    try {
      final repo = ref.read(backupRepositoryProvider);
      await repo.restoreBackup(bytes);

      // Reopen database and notify all consumers.
      ref.invalidate(appDatabaseProvider);

      state = state.copyWith(
        isRestoring: false,
        pendingRestoreManifest: null,
        pendingRestoreBytes: null,
        successMessage: 'backupRestoreSuccess',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isRestoring: false, errorMessage: e.toString());
      return false;
    }
  }

  void cancelPendingRestore() {
    state = state.copyWith(
      pendingRestoreManifest: null,
      pendingRestoreBytes: null,
    );
  }

  void clearFeedback() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}
