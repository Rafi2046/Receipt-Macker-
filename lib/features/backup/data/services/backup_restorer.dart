import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/models/backup_validation_exception.dart';
import 'backup_archive_service.dart';

/// Replaces the live database and images with a backup's, safely:
/// the incoming database is first written beside the live one, opened
/// (which also migrates an older schema) and checked; only then are the
/// live files moved aside and the new ones moved in. Any failure puts the
/// originals back, so a bad or interrupted restore never loses data.
class BackupRestorer {
  const BackupRestorer({this.openDatabase = _open});

  /// Opens a database file; tests may replace it.
  final AppDatabase Function(File file) openDatabase;

  static AppDatabase _open(File file) => AppDatabase(NativeDatabase(file));

  static const String _incoming = '.restore';
  static const String _previous = '.bak';

  /// Tables every QuickBill database has.
  static const List<String> _coreTables = [
    'business_profiles',
    'clients',
    'items',
    'invoices',
  ];

  /// [closeLive] must close the app's open database; it is called only
  /// after the incoming database has passed every check.
  Future<void> restore({
    required File liveDb,
    required Directory liveImages,
    required Uint8List dbBytes,
    required Map<String, Uint8List> mediaFiles,
    required int schemaVersion,
    required Future<void> Function() closeLive,
  }) async {
    final newDb = File('${liveDb.path}$_incoming');
    final newImages = Directory('${liveImages.path}$_incoming');
    final oldDb = File('${liveDb.path}$_previous');
    final oldImages = Directory('${liveImages.path}$_previous');
    await _clear([newDb, oldDb], [newImages, oldImages]);
    try {
      _checkVersion(dbBytes, schemaVersion);
      await newDb.writeAsBytes(dbBytes, flush: true);
      await _verify(newDb);
      await newImages.create(recursive: true);
      for (final MapEntry(key: name, value: bytes) in mediaFiles.entries) {
        if (!BackupArchiveService.isSafeMediaName(name)) continue;
        final file = File(
          '${newImages.path}${Platform.pathSeparator}${name.split('/').last}',
        );
        await file.writeAsBytes(bytes, flush: true);
      }

      await closeLive();
      await _swap(liveDb, liveImages, newDb, newImages, oldDb, oldImages);
    } finally {
      await _clear([newDb, oldDb], [newImages, oldImages]);
    }
  }

  void _checkVersion(Uint8List dbBytes, int schemaVersion) {
    final version = BackupArchiveService.userVersionOf(dbBytes);
    if (version == null || version < 1) {
      throw const BackupValidationException('Database has no schema version');
    }
    if (version > schemaVersion) {
      throw const BackupValidationException(
        'Database is from a newer app version',
        problem: BackupProblem.newerVersion,
      );
    }
  }

  /// Opens [file] as a QuickBill database (migrating it if older), then
  /// checks its integrity and that the core tables can be read.
  Future<void> _verify(File file) async {
    final db = openDatabase(file);
    try {
      final check = await db.customSelect('PRAGMA integrity_check').get();
      final ok = check.length == 1 && check.single.data.values.single == 'ok';
      if (!ok) {
        throw const BackupValidationException('Database failed its check');
      }
      for (final table in _coreTables) {
        await db.customSelect('SELECT COUNT(*) FROM $table').get();
      }
    } on BackupValidationException {
      rethrow;
    } on Object catch (e) {
      throw BackupValidationException(
        'Not a QuickBill database',
        details: e.toString(),
      );
    } finally {
      await db.close();
      await _deleteSidecars(file);
    }
  }

  Future<void> _swap(
    File liveDb,
    Directory liveImages,
    File newDb,
    Directory newImages,
    File oldDb,
    Directory oldImages,
  ) async {
    final hadDb = liveDb.existsSync();
    final hadImages = liveImages.existsSync();
    try {
      await _deleteSidecars(liveDb);
      if (hadDb) await liveDb.rename(oldDb.path);
      if (hadImages) await liveImages.rename(oldImages.path);
      await newDb.rename(liveDb.path);
      await newImages.rename(liveImages.path);
    } on Object {
      // Put the originals back, whatever step failed.
      if (hadDb && oldDb.existsSync()) {
        if (liveDb.existsSync()) await liveDb.delete();
        await oldDb.rename(liveDb.path);
      }
      if (hadImages && oldImages.existsSync()) {
        if (liveImages.existsSync()) await liveImages.delete(recursive: true);
        await oldImages.rename(liveImages.path);
      }
      rethrow;
    }
  }

  Future<void> _deleteSidecars(File db) async {
    for (final suffix in const ['-wal', '-shm', '-journal']) {
      final file = File('${db.path}$suffix');
      if (file.existsSync()) await file.delete();
    }
  }

  Future<void> _clear(List<File> files, List<Directory> dirs) async {
    for (final file in files) {
      if (file.existsSync()) await file.delete();
      await _deleteSidecars(file);
    }
    for (final dir in dirs) {
      if (dir.existsSync()) await dir.delete(recursive: true);
    }
  }
}
