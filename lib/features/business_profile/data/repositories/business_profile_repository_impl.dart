import 'dart:typed_data';

import '../../../../core/database/daos/business_profile_dao.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/image_storage_service.dart';
import '../../domain/models/business_profile.dart';
import '../../domain/models/profile_image_kind.dart';
import '../../domain/repositories/business_profile_repository.dart';
import '../mappers/business_profile_mapper.dart';

class BusinessProfileRepositoryImpl implements BusinessProfileRepository {
  BusinessProfileRepositoryImpl(this._dao, this._images);

  final BusinessProfileDao _dao;
  final ImageStorageService _images;

  static Failure _db(Object e, StackTrace s) =>
      DatabaseFailure(cause: e, stackTrace: s);

  static Failure _storage(Object e, StackTrace s) =>
      StorageFailure(cause: e, stackTrace: s);

  @override
  Stream<BusinessProfile?> watch() =>
      _dao.watchPrimary().map((row) => row?.toDomain());

  @override
  Future<Result<BusinessProfile?>> load() => Result.guard(() async {
    final row = await _dao.getPrimary();
    return row?.toDomain();
  }, onError: _db);

  @override
  Future<Result<BusinessProfile>> save(BusinessProfile profile) =>
      Result.guard(() async {
        final row = profile.toRow();
        await _dao.upsert(row);
        return row.toDomain();
      }, onError: _db);

  @override
  Future<Result<String>> storeImage(
    ProfileImageKind kind,
    Uint8List bytes, {
    required String extension,
  }) => Result.guard(
    () => _images.save(bytes, prefix: kind.filePrefix, extension: extension),
    onError: _storage,
  );

  @override
  Future<Result<void>> deleteImage(String relativePath) =>
      Result.guard(() => _images.delete(relativePath), onError: _storage);

  @override
  Future<String> resolveImagePath(String relativePath) =>
      _images.absolutePath(relativePath);
}
