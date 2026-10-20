import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/utils/validation_error.dart';
import '../../domain/logic/client_field_access.dart';
import '../../domain/models/client.dart';
import '../../domain/models/client_field.dart';

part 'client_editor_state.freezed.dart';

@freezed
abstract class ClientEditorState with _$ClientEditorState {
  const factory ClientEditorState({
    /// What the user is editing.
    required Client draft,

    /// The client as loaded (or blank when new), for unsaved-change checks.
    required Client initial,
    required bool isNew,
    @Default({}) Map<ClientField, ValidationError> errors,

    /// Errors show only after the first save attempt, not while typing.
    @Default(false) bool showErrors,
    @Default(false) bool isSaving,
    @Default(false) bool isDeleting,

    /// Last failure, shown once as a snackbar, then cleared.
    Failure? failure,
  }) = _ClientEditorState;

  const ClientEditorState._();

  ValidationError? errorFor(ClientField field) =>
      showErrors ? errors[field] : null;

  bool get hasUnsavedChanges => !draft.sameContentAs(initial);

  bool get isBusy => isSaving || isDeleting;
}
