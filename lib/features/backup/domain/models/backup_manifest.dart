import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_manifest.freezed.dart';
part 'backup_manifest.g.dart';

@freezed
abstract class BackupManifest with _$BackupManifest {
  const factory BackupManifest({
    required int version,
    required int schemaVersion,
    required DateTime createdAt,
    required int invoiceCount,
    required int clientCount,
    required int itemCount,
    @Default(0) int paymentCount,
    @Default(<String>[]) List<String> mediaFiles,
  }) = _BackupManifest;

  factory BackupManifest.fromJson(Map<String, dynamic> json) =>
      _$BackupManifestFromJson(json);
}
