import 'dart:typed_data';

import '../../../../core/errors/result.dart';
import '../models/business_profile.dart';
import '../models/profile_image_kind.dart';

abstract interface class BusinessProfileRepository {
  /// The primary profile; emits null until onboarding saves one.
  Stream<BusinessProfile?> watch();

  Future<Result<BusinessProfile?>> load();

  Future<Result<BusinessProfile>> save(BusinessProfile profile);

  /// Stores image bytes as a file and returns its relative path.
  Future<Result<String>> storeImage(
    ProfileImageKind kind,
    Uint8List bytes, {
    required String extension,
  });

  Future<Result<void>> deleteImage(String relativePath);

  /// Absolute path for showing a stored image.
  Future<String> resolveImagePath(String relativePath);
}
