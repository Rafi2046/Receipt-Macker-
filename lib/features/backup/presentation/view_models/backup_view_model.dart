import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database_provider.dart';
import '../../../../core/services/telemetry/analytics_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/models/backup_validation_exception.dart';
import '../../providers.dart';
import 'backup_state.dart';

part 'backup_view_model.g.dart';

@riverpod
class BackupViewModel extends _$BackupViewModel {
  /// Keys of the error texts; the view turns them into the user's language.
  static const String errorInvalid = 'backupErrorInvalid';
  static const String errorNewer = 'backupErrorNewer';
  static const String errorTooLarge = 'backupErrorTooLarge';
  static const String errorFailed = 'backupErrorFailed';

  static String _keyFor(BackupProblem problem) => switch (problem) {
    BackupProblem.invalid => errorInvalid,
    BackupProblem.newerVersion => errorNewer,
    BackupProblem.tooLarge => errorTooLarge,
  };

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
      unawaited(ref.read(analyticsServiceProvider).logBackupExported());
      state = state.copyWith(
        isCreatingBackup: false,
        lastBackupDate: repo.getLastBackupDate(),
        successMessage: 'backupExportSuccess',
      );
    } on Object catch (e, st) {
      AppLogger.error('backup export', e, st);
      state = state.copyWith(
        isCreatingBackup: false,
        errorMessage: errorFailed,
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
      state = state.copyWith(errorMessage: _keyFor(e.problem));
    } on Object catch (e, st) {
      AppLogger.error('backup pick', e, st);
      state = state.copyWith(errorMessage: errorFailed);
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
      state = state.copyWith(
        isRestoring: false,
        pendingRestoreManifest: null,
        pendingRestoreBytes: null,
        successMessage: 'backupRestoreSuccess',
      );
      return true;
    } on BackupValidationException catch (e) {
      state = state.copyWith(
        isRestoring: false,
        pendingRestoreManifest: null,
        pendingRestoreBytes: null,
        errorMessage: _keyFor(e.problem),
      );
      return false;
    } on Object catch (e, st) {
      AppLogger.error('backup restore', e, st);
      state = state.copyWith(isRestoring: false, errorMessage: errorFailed);
      return false;
    } finally {
      // The restore may have closed the database, whether or not it
      // finished; reopen it for every consumer either way.
      ref.invalidate(appDatabaseProvider);
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
