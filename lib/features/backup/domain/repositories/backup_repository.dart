import 'dart:io';
import 'dart:typed_data';

import '../models/backup_manifest.dart';

/// Contract for creating, sharing, validating, and restoring database backups.
abstract interface class BackupRepository {
  /// Bundles database and media assets into a timestamped .zip archive file in cache.
  Future<File> createBackup({DateTime? timestamp});

  /// Validates a zip archive's integrity, manifest, and database header.
  /// Returns the validated [BackupManifest] if valid, or throws [BackupValidationException].
  Future<BackupManifest> validateBackup(Uint8List zipBytes);

  /// Restores the database and media assets from [zipBytes].
  Future<void> restoreBackup(Uint8List zipBytes);

  /// Opens the system share sheet to share the backup file.
  Future<bool> shareBackup(File zipFile);

  /// Picks a `.zip` file from the device storage.
  Future<Uint8List?> pickBackupFile();

  /// Returns the timestamp of the last backup, or null.
  DateTime? getLastBackupDate();

  /// Updates the timestamp of the last backup.
  Future<void> setLastBackupDate(DateTime date);
}
