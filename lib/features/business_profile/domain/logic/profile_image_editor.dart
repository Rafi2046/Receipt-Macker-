import 'dart:typed_data';

import '../../../../core/errors/result.dart';
import '../models/profile_image_kind.dart';
import '../repositories/business_profile_repository.dart';

/// Keeps image files in step with an edited profile: a replaced image that was
/// never saved is deleted at once; the old saved image is deleted only after
/// the profile that stops using it is saved. No orphan files either way.
class ProfileImageEditor {
  const ProfileImageEditor(this._repository);

  final BusinessProfileRepository _repository;

  /// Stores [bytes] and drops [current] if it is an unsaved draft image.
  Future<Result<String>> replace(
    ProfileImageKind kind,
    Uint8List bytes, {
    required String extension,
    required String? current,
    required String? persisted,
  }) async {
    final stored = await _repository.storeImage(
      kind,
      bytes,
      extension: extension,
    );
    if (stored is Ok<String>) await discardDraft(current, persisted: persisted);
    return stored;
  }

  /// Deletes [draft] unless it is the saved image.
  Future<void> discardDraft(String? draft, {required String? persisted}) async {
    if (draft != null && draft != persisted) {
      await _repository.deleteImage(draft);
    }
  }

  /// After saving: deletes the previously saved image if it was replaced or removed.
  Future<void> afterSave({
    required String? previous,
    required String? saved,
  }) async {
    if (previous != null && previous != saved) {
      await _repository.deleteImage(previous);
    }
  }
}
