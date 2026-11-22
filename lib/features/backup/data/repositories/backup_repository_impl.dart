import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/services/image_storage_service.dart';
import '../../../../core/services/preferences/app_preferences.dart';
import '../../../../core/services/share_service.dart';
import '../../domain/models/backup_manifest.dart';
import '../../domain/repositories/backup_repository.dart';
import '../services/backup_archive_service.dart';
import '../services/backup_file_picker_service.dart';
import '../services/backup_restorer.dart';

class BackupRepositoryImpl implements BackupRepository {
  BackupRepositoryImpl({
    required this.db,
    required this.prefs,
    required this.shareService,
    this.archiveService = const BackupArchiveService(),
    this.pickerService = const BackupFilePickerService(),
    this.restorer = const BackupRestorer(),
    Future<Directory> Function()? documentsDirectory,
    Future<Directory> Function()? temporaryDirectory,
  }) : _documentsDirectory =
           documentsDirectory ?? getApplicationDocumentsDirectory,
       _temporaryDirectory = temporaryDirectory ?? getTemporaryDirectory;

  final AppDatabase db;
  final AppPreferences prefs;
  final ShareService shareService;
  final BackupArchiveService archiveService;
  final BackupFilePickerService pickerService;
  final BackupRestorer restorer;
  final Future<Directory> Function() _documentsDirectory;
  final Future<Directory> Function() _temporaryDirectory;

  @override
  Future<File> createBackup({DateTime? timestamp}) async {
    // 1. Flush/truncate SQLite WAL log to ensure all transactions are in app.sqlite.
    await db.customStatement('PRAGMA wal_checkpoint(TRUNCATE);');

    // 2. Fetch record counts.
    final invoiceCount = await db
        .customSelect('SELECT COUNT(*) AS c FROM invoices')
        .getSingle()
        .then((r) => r.read<int>('c'));
    final clientCount = await db
        .customSelect('SELECT COUNT(*) AS c FROM clients')
        .getSingle()
        .then((r) => r.read<int>('c'));
    final itemCount = await db
        .customSelect('SELECT COUNT(*) AS c FROM items')
        .getSingle()
        .then((r) => r.read<int>('c'));
    final paymentCount = await db
        .customSelect('SELECT COUNT(*) AS c FROM payments')
        .getSingle()
        .then((r) => r.read<int>('c'));

    // 3. Read SQLite database file.
    final docDir = await _documentsDirectory();
    final dbFile = File(
      '${docDir.path}${Platform.pathSeparator}${AppConstants.databaseFileName}',
    );
    if (!await dbFile.exists()) {
      throw StateError('Database file does not exist at ${dbFile.path}');
    }
    final dbBytes = await dbFile.readAsBytes();

    // 4. Collect business media files (logo, signature).
    final imagesDir = Directory(
      '${docDir.path}${Platform.pathSeparator}${ImageStorageService.folder}',
    );
    final mediaFiles = <String, Uint8List>{};
    final mediaPaths = <String>[];
    if (await imagesDir.exists()) {
      await for (final entity in imagesDir.list(recursive: true)) {
        if (entity is File) {
          final relative = entity.path
              .substring(docDir.path.length + 1)
              .replaceAll(r'\', '/');
          final bytes = await entity.readAsBytes();
          mediaFiles[relative] = bytes;
          mediaPaths.add(relative);
        }
      }
    }

    // 5. Build manifest.
    final now = timestamp ?? DateTime.now();
    final manifest = BackupManifest(
      version: 1,
      schemaVersion: db.schemaVersion,
      createdAt: now,
      invoiceCount: invoiceCount,
      clientCount: clientCount,
      itemCount: itemCount,
      paymentCount: paymentCount,
      mediaFiles: mediaPaths,
    );

    // 6. Zip archive.
    final zipBytes = archiveService.createZip(
      manifest: manifest,
      dbBytes: dbBytes,
      mediaFiles: mediaFiles,
    );

    // 7. Write to cache/temp file.
    final tempDir = await _temporaryDirectory();
    String pad(int n) => n.toString().padLeft(2, '0');
    final dateStr =
        '${now.year}${pad(now.month)}${pad(now.day)}_${pad(now.hour)}${pad(now.minute)}${pad(now.second)}';
    final fileName = 'quickbill_backup_$dateStr.zip';
    final zipFile = File('${tempDir.path}${Platform.pathSeparator}$fileName');
    await zipFile.writeAsBytes(zipBytes, flush: true);

    // 8. Update last backup timestamp.
    await setLastBackupDate(now);

    return zipFile;
  }

  @override
  Future<BackupManifest> validateBackup(Uint8List zipBytes) async {
    final result = archiveService.readAndValidateZip(
      zipBytes,
      currentSchemaVersion: db.schemaVersion,
    );
    return result.manifest;
  }

  @override
  Future<void> restoreBackup(Uint8List zipBytes) async {
    // Validate before touching live data; the restorer then checks the
    // database itself and swaps the files atomically.
    final result = archiveService.readAndValidateZip(
      zipBytes,
      currentSchemaVersion: db.schemaVersion,
    );
    final docDir = await _documentsDirectory();
    final sep = Platform.pathSeparator;
    await restorer.restore(
      liveDb: File('${docDir.path}$sep${AppConstants.databaseFileName}'),
      liveImages: Directory('${docDir.path}$sep${ImageStorageService.folder}'),
      dbBytes: result.dbBytes,
      mediaFiles: result.mediaFiles,
      schemaVersion: db.schemaVersion,
      closeLive: db.close,
    );
  }

  @override
  Future<bool> shareBackup(File zipFile) async {
    final name = zipFile.uri.pathSegments.isNotEmpty
        ? zipFile.uri.pathSegments.last
        : 'quickbill_backup.zip';
    return shareService.shareFile(
      zipFile.path,
      mimeType: 'application/zip',
      subject: name,
    );
  }

  @override
  Future<Uint8List?> pickBackupFile() => pickerService.pickBackupZip();

  @override
  DateTime? getLastBackupDate() {
    final millis = prefs.lastBackupMillis;
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
  }

  @override
  Future<void> setLastBackupDate(DateTime date) =>
      prefs.setLastBackupMillis(date.millisecondsSinceEpoch);
}
