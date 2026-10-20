import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/utils/validation_error.dart';
import '../../domain/logic/profile_field_access.dart';
import '../../domain/models/business_profile.dart';
import '../../domain/models/profile_field.dart';

part 'profile_form_state.freezed.dart';

@freezed
abstract class ProfileFormState with _$ProfileFormState {
  const factory ProfileFormState({
    /// What the user is editing.
    required BusinessProfile draft,

    /// The stored profile; null during onboarding before the first save.
    BusinessProfile? saved,
    @Default({}) Map<ProfileField, ValidationError> errors,

    /// Errors show only after the first submit attempt, not while typing.
    @Default(false) bool showErrors,
    @Default(false) bool isSaving,
    @Default(false) bool isPickingImage,

    /// Last failure, shown once as a snackbar, then cleared.
    Failure? failure,
  }) = _ProfileFormState;

  const ProfileFormState._();

  ValidationError? errorFor(ProfileField field) =>
      showErrors ? errors[field] : null;

  bool get hasUnsavedChanges => !draft.sameContentAs(saved);
}
