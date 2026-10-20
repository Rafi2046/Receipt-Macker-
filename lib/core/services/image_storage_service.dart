import 'dart:io';
import 'dart:typed_data';

import '../utils/id_generator.dart';

/// Stores user images (logo, signature) as files under the app documents
/// directory. Callers keep the returned relative path, so backups and a
/// changed sandbox path keep working.
class ImageStorageService {
  ImageStorageService(this._rootDirectory);

  final Future<Directory> Function() _rootDirectory;

  static const String folder = 'images';

  /// Writes [bytes] to `images/<prefix>_<id>.<extension>`; returns that path.
  Future<String> save(
    Uint8List bytes, {
    required String prefix,
    required String extension,
  }) async {
    final relative = '$folder/${prefix}_${IdGenerator.next()}.$extension';
    final file = File(await absolutePath(relative));
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    return relative;
  }

  Future<String> absolutePath(String relativePath) async {
    final root = await _rootDirectory();
    return '${root.path}${Platform.pathSeparator}$relativePath';
  }

  /// Deletes the file; a missing file is not an error.
  Future<void> delete(String relativePath) async {
    final file = File(await absolutePath(relativePath));
    if (await file.exists()) await file.delete();
  }
}
