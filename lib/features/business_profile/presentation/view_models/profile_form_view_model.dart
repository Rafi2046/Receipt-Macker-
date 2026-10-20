import 'dart:async';
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/services/service_providers.dart';
import '../../../../core/utils/id_generator.dart';
import '../../domain/logic/business_profile_validator.dart';
import '../../domain/logic/profile_field_access.dart';
import '../../domain/logic/profile_image_editor.dart';
import '../../domain/models/business_profile.dart';
import '../../domain/models/profile_field.dart';
import '../../domain/models/profile_image_kind.dart';
import '../../providers.dart';
import 'profile_form_state.dart';

part 'profile_form_view_model.g.dart';

/// Edits the business profile. Used by onboarding (no saved profile yet) and
/// by the business profile screen. Unsaved images are deleted on dispose.
@riverpod
class ProfileFormViewModel extends _$ProfileFormViewModel {
  late ProfileImageEditor _images;

  /// Last known form. Kept outside [state] because `onDispose` may not read
  /// state or ref.
  ProfileFormState? _latest;

  ProfileFormState? get _form => state.value;

  @override
  Future<ProfileFormState> build() async {
    final repo = ref.watch(businessProfileRepositoryProvider);
    final images = _images = ProfileImageEditor(repo);
    final saved = switch (await repo.load()) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
    final now = DateTime.now().toUtc();
    final draft =
        saved ??
        BusinessProfile(
          id: IdGenerator.next(),
          name: '',
          createdAt: now,
          updatedAt: now,
        );
    ref.onDispose(() => unawaited(_discardDraftImages(images, _latest)));
    return _latest = ProfileFormState(
      draft: draft,
      saved: saved,
      errors: BusinessProfileValidator.validate(draft),
    );
  }

  void _set(ProfileFormState Function(ProfileFormState form) update) {
    final form = _form;
    if (form != null) state = AsyncData(_latest = update(form));
  }

  void updateField(ProfileField field, String value) => _set((f) {
    final draft = f.draft.withField(field, value);
    return f.copyWith(
      draft: draft,
      errors: BusinessProfileValidator.validate(draft),
    );
  });

  /// Shows any errors; returns true when the draft can be saved.
  bool validate() {
    _set((f) => f.copyWith(showErrors: true));
    return _form?.errors.isEmpty ?? false;
  }

  Future<void> pickLogo() async {
    _set((f) => f.copyWith(isPickingImage: true));
    final picked = await ref.read(imagePickerServiceProvider).pickFromGallery();
    _set((f) => f.copyWith(isPickingImage: false));
    if (picked == null) return;
    await _storeImage(ProfileImageKind.logo, picked.bytes, picked.extension);
  }

  Future<void> setSignature(Uint8List png) =>
      _storeImage(ProfileImageKind.signature, png, 'png');

  Future<void> removeLogo() => _removeImage(ProfileImageKind.logo);

  Future<void> removeSignature() => _removeImage(ProfileImageKind.signature);

  void clearFailure() => _set((f) => f.copyWith(failure: null));

  /// Validates and saves. Returns true on success.
  Future<bool> save() async {
    final form = _form;
    if (form == null || !validate()) return false;
    _set((f) => f.copyWith(isSaving: true));
    final repo = ref.read(businessProfileRepositoryProvider);
    final result = await repo.save(
      form.draft.copyWith(updatedAt: DateTime.now().toUtc()),
    );
    switch (result) {
      case Ok(:final value):
        await _images.afterSave(
          previous: form.saved?.logoPath,
          saved: value.logoPath,
        );
        await _images.afterSave(
          previous: form.saved?.signaturePath,
          saved: value.signaturePath,
        );
        _set((f) => f.copyWith(draft: value, saved: value, isSaving: false));
        return true;
      case Err(:final failure):
        _set((f) => f.copyWith(isSaving: false, failure: failure));
        return false;
    }
  }

  Future<void> _storeImage(
    ProfileImageKind kind,
    Uint8List bytes,
    String extension,
  ) async {
    final form = _form;
    if (form == null) return;
    final result = await _images.replace(
      kind,
      bytes,
      extension: extension,
      current: _pathOf(form.draft, kind),
      persisted: _pathOf(form.saved, kind),
    );
    switch (result) {
      case Ok(:final value):
        _set((f) => f.copyWith(draft: _withPath(f.draft, kind, value)));
      case Err(:final failure):
        _set((f) => f.copyWith(failure: failure));
    }
  }

  Future<void> _removeImage(ProfileImageKind kind) async {
    final form = _form;
    if (form == null) return;
    await _images.discardDraft(
      _pathOf(form.draft, kind),
      persisted: _pathOf(form.saved, kind),
    );
    _set((f) => f.copyWith(draft: _withPath(f.draft, kind, null)));
  }

  static Future<void> _discardDraftImages(
    ProfileImageEditor images,
    ProfileFormState? form,
  ) async {
    if (form == null) return;
    for (final kind in ProfileImageKind.values) {
      await images.discardDraft(
        _pathOf(form.draft, kind),
        persisted: _pathOf(form.saved, kind),
      );
    }
  }

  static String? _pathOf(BusinessProfile? p, ProfileImageKind kind) =>
      switch (kind) {
        ProfileImageKind.logo => p?.logoPath,
        ProfileImageKind.signature => p?.signaturePath,
      };

  static BusinessProfile _withPath(
    BusinessProfile p,
    ProfileImageKind kind,
    String? path,
  ) => switch (kind) {
    ProfileImageKind.logo => p.copyWith(logoPath: path),
    ProfileImageKind.signature => p.copyWith(signaturePath: path),
  };
}
