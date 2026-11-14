import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/backup_manifest.dart';

part 'backup_state.freezed.dart';

@freezed
abstract class BackupState with _$BackupState {
  const factory BackupState({
    @Default(false) bool isCreatingBackup,
    @Default(false) bool isRestoring,
    DateTime? lastBackupDate,
    BackupManifest? pendingRestoreManifest,
    @Uint8ListConverter() Uint8List? pendingRestoreBytes,
    String? errorMessage,
    String? successMessage,
  }) = _BackupState;
}

class Uint8ListConverter implements JsonConverter<Uint8List?, List<int>?> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(List<int>? json) =>
      json == null ? null : Uint8List.fromList(json);

  @override
  List<int>? toJson(Uint8List? object) => object;
}
