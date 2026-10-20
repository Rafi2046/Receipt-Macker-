import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Saves bytes where the user picks (Downloads, Drive…) with the system
/// "save to" screen. Needs no storage permission.
class FileSaveService {
  /// Returns true when saved, false when the user cancelled.
  Future<bool> save({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  }) async {
    final uri = await FilePicker.saveFile(
      fileName: fileName,
      bytes: bytes,
      mimeType: mimeType,
    );
    return uri != null;
  }
}
