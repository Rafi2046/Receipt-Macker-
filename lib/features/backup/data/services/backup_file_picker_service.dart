import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import '../../domain/models/backup_validation_exception.dart';
import 'backup_archive_service.dart';

/// Wraps [FilePicker] to pick backup .zip archives.
class BackupFilePickerService {
  const BackupFilePickerService();

  Future<Uint8List?> pickBackupZip() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result.isEmpty) return null;
    final file = result.first.xFile;
    // Refuse a huge file before reading it into memory.
    if (await file.length() > BackupArchiveService.maxZipBytes) {
      throw const BackupValidationException(
        'Backup file is too large',
        problem: BackupProblem.tooLarge,
      );
    }
    return file.readAsBytes();
  }
}
