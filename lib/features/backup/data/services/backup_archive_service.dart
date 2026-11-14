import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import '../../domain/models/backup_manifest.dart';
import '../../domain/models/backup_validation_exception.dart';

/// Service responsible for packing and unpacking backup .zip archives.
class BackupArchiveService {
  const BackupArchiveService();

  static const List<int> _sqliteMagicHeader = [
    0x53,
    0x51,
    0x4c,
    0x69,
    0x74,
    0x65,
    0x20,
    0x66,
    0x6f,
    0x72,
    0x6d,
    0x61,
    0x74,
    0x20,
    0x33,
    0x00,
  ];

  static const String manifestFileName = 'manifest.json';
  static const String dbFileName = 'app.sqlite';

  /// Compresses the manifest, sqlite database, and media files into a zip archive.
  Uint8List createZip({
    required BackupManifest manifest,
    required Uint8List dbBytes,
    required Map<String, Uint8List> mediaFiles,
  }) {
    final archive = Archive();

    // 1. Manifest
    final manifestBytes = utf8.encode(jsonEncode(manifest.toJson()));
    archive.addFile(
      ArchiveFile(manifestFileName, manifestBytes.length, manifestBytes),
    );

    // 2. SQLite Database
    archive.addFile(ArchiveFile(dbFileName, dbBytes.length, dbBytes));

    // 3. Media files
    for (final entry in mediaFiles.entries) {
      archive.addFile(ArchiveFile(entry.key, entry.value.length, entry.value));
    }

    final encoded = ZipEncoder().encode(archive);
    return Uint8List.fromList(encoded);
  }

  /// Decodes and validates a zip archive.
  /// Throws [BackupValidationException] if validation fails.
  ({
    BackupManifest manifest,
    Uint8List dbBytes,
    Map<String, Uint8List> mediaFiles,
  })
  readAndValidateZip(Uint8List zipBytes, {required int currentSchemaVersion}) {
    Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(zipBytes);
    } catch (e) {
      throw BackupValidationException(
        'Invalid or corrupted zip archive',
        details: e.toString(),
      );
    }

    // 1. Validate manifest
    final manifestFile = archive.findFile(manifestFileName);
    if (manifestFile == null) {
      throw const BackupValidationException('Missing manifest.json in archive');
    }

    BackupManifest manifest;
    try {
      final manifestRaw = manifestFile.content as List<int>;
      final manifestJson =
          jsonDecode(utf8.decode(manifestRaw)) as Map<String, dynamic>;
      manifest = BackupManifest.fromJson(manifestJson);
    } catch (e) {
      throw BackupValidationException(
        'Malformed manifest.json',
        details: e.toString(),
      );
    }

    // 2. Validate schema compatibility
    if (manifest.schemaVersion > currentSchemaVersion) {
      throw BackupValidationException(
        'Backup from newer version (schema v${manifest.schemaVersion}) cannot be restored in this app (v$currentSchemaVersion). Please update QuickBill.',
      );
    }
    if (manifest.schemaVersion < 1) {
      throw BackupValidationException(
        'Invalid schema version: ${manifest.schemaVersion}',
      );
    }

    // 3. Validate database file
    final dbFile = archive.findFile(dbFileName);
    if (dbFile == null) {
      throw const BackupValidationException(
        'Missing database file ($dbFileName) in archive',
      );
    }

    final dbBytes = Uint8List.fromList(dbFile.content as List<int>);
    if (dbBytes.isEmpty) {
      throw const BackupValidationException(
        'Database file in archive is empty',
      );
    }

    if (!_matchesSqliteHeader(dbBytes)) {
      throw const BackupValidationException(
        'Corrupted database file: invalid SQLite header',
      );
    }

    // 4. Extract media files
    final mediaFiles = <String, Uint8List>{};
    for (final file in archive.files) {
      if (file.name == manifestFileName || file.name == dbFileName) continue;
      if (file.name.startsWith('images/') || file.name.startsWith('images\\')) {
        mediaFiles[file.name] = Uint8List.fromList(file.content as List<int>);
      }
    }

    return (manifest: manifest, dbBytes: dbBytes, mediaFiles: mediaFiles);
  }

  bool _matchesSqliteHeader(Uint8List bytes) {
    if (bytes.length < _sqliteMagicHeader.length) return false;
    for (var i = 0; i < _sqliteMagicHeader.length; i++) {
      if (bytes[i] != _sqliteMagicHeader[i]) return false;
    }
    return true;
  }
}
