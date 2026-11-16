import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/features/backup/data/services/backup_archive_service.dart';
import 'package:receipt_maker/features/backup/domain/models/backup_manifest.dart';
import 'package:receipt_maker/features/backup/domain/models/backup_validation_exception.dart';

void main() {
  const service = BackupArchiveService();

  final sqliteValidHeader = Uint8List.fromList([
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
    ...List.filled(84, 0),
  ]);

  final sampleManifest = BackupManifest(
    version: 1,
    schemaVersion: 6,
    createdAt: DateTime.utc(2026, 11, 14, 20),
    invoiceCount: 12,
    clientCount: 4,
    itemCount: 8,
    paymentCount: 5,
    mediaFiles: ['images/logo_1.png'],
  );

  test('createZip and readAndValidateZip pack and unpack correctly', () {
    final media = {
      'images/logo_1.png': Uint8List.fromList([1, 2, 3, 4]),
    };

    final zipBytes = service.createZip(
      manifest: sampleManifest,
      dbBytes: sqliteValidHeader,
      mediaFiles: media,
    );

    final result = service.readAndValidateZip(
      zipBytes,
      currentSchemaVersion: 6,
    );

    expect(result.manifest.version, 1);
    expect(result.manifest.schemaVersion, 6);
    expect(result.manifest.invoiceCount, 12);
    expect(result.manifest.clientCount, 4);
    expect(result.manifest.itemCount, 8);
    expect(result.manifest.paymentCount, 5);
    expect(result.dbBytes, sqliteValidHeader);
    expect(result.mediaFiles.containsKey('images/logo_1.png'), isTrue);
    expect(result.mediaFiles['images/logo_1.png'], [1, 2, 3, 4]);
  });

  test('throws BackupValidationException on non-zip bytes', () {
    final garbage = Uint8List.fromList([99, 98, 97]);
    expect(
      () => service.readAndValidateZip(garbage, currentSchemaVersion: 6),
      throwsA(isA<BackupValidationException>()),
    );
  });

  test('throws when manifest.json is missing', () {
    final archive = Archive();
    archive.addFile(
      ArchiveFile('app.sqlite', sqliteValidHeader.length, sqliteValidHeader),
    );
    final zip = Uint8List.fromList(ZipEncoder().encode(archive));

    expect(
      () => service.readAndValidateZip(zip, currentSchemaVersion: 6),
      throwsA(
        isA<BackupValidationException>().having(
          (e) => e.message,
          'message',
          contains('Missing manifest.json'),
        ),
      ),
    );
  });

  test('throws when manifest.json is malformed JSON', () {
    final archive = Archive();
    archive.addFile(ArchiveFile.string('manifest.json', 'not-valid-json'));
    archive.addFile(
      ArchiveFile('app.sqlite', sqliteValidHeader.length, sqliteValidHeader),
    );
    final zip = Uint8List.fromList(ZipEncoder().encode(archive));

    expect(
      () => service.readAndValidateZip(zip, currentSchemaVersion: 6),
      throwsA(
        isA<BackupValidationException>().having(
          (e) => e.message,
          'message',
          contains('Malformed manifest.json'),
        ),
      ),
    );
  });

  test('throws when schemaVersion is higher than current', () {
    final highSchemaManifest = sampleManifest.copyWith(schemaVersion: 99);
    final zip = service.createZip(
      manifest: highSchemaManifest,
      dbBytes: sqliteValidHeader,
      mediaFiles: {},
    );

    expect(
      () => service.readAndValidateZip(zip, currentSchemaVersion: 6),
      throwsA(
        isA<BackupValidationException>().having(
          (e) => e.message,
          'message',
          contains('schema v99'),
        ),
      ),
    );
  });

  test('throws when schemaVersion is invalid (< 1)', () {
    final invalidSchemaManifest = sampleManifest.copyWith(schemaVersion: 0);
    final zip = service.createZip(
      manifest: invalidSchemaManifest,
      dbBytes: sqliteValidHeader,
      mediaFiles: {},
    );

    expect(
      () => service.readAndValidateZip(zip, currentSchemaVersion: 6),
      throwsA(
        isA<BackupValidationException>().having(
          (e) => e.message,
          'message',
          contains('Invalid schema version'),
        ),
      ),
    );
  });

  test('throws when database file is missing from archive', () {
    final archive = Archive();
    final manifestBytes = utf8.encode(jsonEncode(sampleManifest.toJson()));
    archive.addFile(
      ArchiveFile('manifest.json', manifestBytes.length, manifestBytes),
    );
    final zip = Uint8List.fromList(ZipEncoder().encode(archive));

    expect(
      () => service.readAndValidateZip(zip, currentSchemaVersion: 6),
      throwsA(
        isA<BackupValidationException>().having(
          (e) => e.message,
          'message',
          contains('Missing database file'),
        ),
      ),
    );
  });

  test('throws when database file is empty', () {
    final archive = Archive();
    final manifestBytes = utf8.encode(jsonEncode(sampleManifest.toJson()));
    archive.addFile(
      ArchiveFile('manifest.json', manifestBytes.length, manifestBytes),
    );
    archive.addFile(ArchiveFile('app.sqlite', 0, Uint8List(0)));
    final zip = Uint8List.fromList(ZipEncoder().encode(archive));

    expect(
      () => service.readAndValidateZip(zip, currentSchemaVersion: 6),
      throwsA(
        isA<BackupValidationException>().having(
          (e) => e.message,
          'message',
          contains('empty'),
        ),
      ),
    );
  });

  test('throws when SQLite header is invalid', () {
    final corruptDb = Uint8List.fromList(List.filled(100, 42));
    final zip = service.createZip(
      manifest: sampleManifest,
      dbBytes: corruptDb,
      mediaFiles: {},
    );

    expect(
      () => service.readAndValidateZip(zip, currentSchemaVersion: 6),
      throwsA(
        isA<BackupValidationException>().having(
          (e) => e.message,
          'message',
          contains('invalid SQLite header'),
        ),
      ),
    );
  });
}
