import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/utils/validation_error.dart';
import '../../domain/logic/invoice_calculator.dart';
import '../../domain/logic/invoice_drafting.dart';
import '../../domain/models/due_term.dart';
import '../../domain/models/invoice.dart';
import '../../domain/models/invoice_field.dart';
import '../../domain/models/invoice_totals.dart';
import '../../domain/models/invoice_validation.dart';
import '../../domain/models/line_field.dart';

part 'invoice_editor_state.freezed.dart';

@freezed
abstract class InvoiceEditorState with _$InvoiceEditorState {
  const factory InvoiceEditorState({
    /// What the user is editing.
    required Invoice draft,

    /// The invoice as loaded (or as first filled in), for unsaved changes.
    required Invoice initial,
    required bool isNew,

    /// A new invoice copied from another; leaving it asks first.
    @Default(false) bool isCopy,
    @Default(InvoiceValidation()) InvoiceValidation validation,

    /// Set when saving found another invoice with the same number.
    @Default(false) bool numberTaken,

    /// Errors show only after the first save attempt, not while typing.
    @Default(false) bool showErrors,
    @Default(false) bool isSaving,

    /// Lines added from an item priced in another currency (line id to
    /// that currency); their price was left empty for the user to enter.
    @Default({}) Map<String, String> foreignPriceLines,

    /// Last failure, shown once as a snackbar, then cleared.
    Failure? failure,
  }) = _InvoiceEditorState;

  const InvoiceEditorState._();

  InvoiceTotals get totals => InvoiceCalculator.calculate(draft);

  DueTerm get dueTerm => draft.dueTerm;

  ValidationError? errorFor(InvoiceField field) {
    if (!showErrors) return null;
    if (field == InvoiceField.number && numberTaken) {
      return ValidationError.numberTaken;
    }
    return validation.fields[field];
  }

  Map<LineField, ValidationError> lineErrors(String lineId) =>
      showErrors ? validation.forLine(lineId) : const {};

  bool get canSave => validation.isValid && !numberTaken;

  bool get hasUnsavedChanges =>
      (isNew && isCopy) || !draft.sameContentAs(initial);
}
