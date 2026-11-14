import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Wraps [FilePicker] to pick backup .zip archives.
class BackupFilePickerService {
  const BackupFilePickerService();

  Future<Uint8List?> pickBackupZip() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result.isEmpty) return null;
    final file = result.first;
    return file.xFile.readAsBytes();
  }
}
