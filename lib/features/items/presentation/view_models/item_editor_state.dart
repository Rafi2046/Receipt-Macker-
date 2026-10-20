import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/utils/validation_error.dart';
import '../../domain/logic/item_content.dart';
import '../../domain/models/item.dart';
import '../../domain/models/item_field.dart';

part 'item_editor_state.freezed.dart';

@freezed
abstract class ItemEditorState with _$ItemEditorState {
  const factory ItemEditorState({
    /// What the user is editing.
    required Item draft,

    /// The item as loaded (or blank when new), for unsaved-change checks.
    required Item initial,
    required bool isNew,

    /// False while the price field is empty ([draft] then holds 0).
    required bool hasPrice,
    @Default({}) Map<ItemField, ValidationError> errors,

    /// Errors show only after the first save attempt, not while typing.
    @Default(false) bool showErrors,
    @Default(false) bool isSaving,
    @Default(false) bool isDeleting,

    /// Last failure, shown once as a snackbar, then cleared.
    Failure? failure,
  }) = _ItemEditorState;

  const ItemEditorState._();

  ValidationError? errorFor(ItemField field) =>
      showErrors ? errors[field] : null;

  /// A new item starts without a price; an existing one with its price.
  bool get hasUnsavedChanges =>
      !draft.sameContentAs(initial) || hasPrice == isNew;

  bool get isBusy => isSaving || isDeleting;
}
