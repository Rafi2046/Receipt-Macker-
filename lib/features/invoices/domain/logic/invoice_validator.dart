import '../../../../core/utils/money.dart';
import '../../../../core/utils/validation_error.dart';
import '../../../../core/utils/validators.dart';
import '../models/discount.dart';
import '../models/discount_type.dart';
import '../models/invoice.dart';
import '../models/invoice_field.dart';
import '../models/invoice_validation.dart';
import '../models/line_field.dart';
import '../models/line_item.dart';
import 'invoice_calculator.dart';

/// Checks an invoice before saving. Number uniqueness needs the database
/// and is checked by the repository.
abstract final class InvoiceValidator {
  static const int maxNumberLength = 40;

  static InvoiceValidation validate(Invoice invoice) {
    final totals = InvoiceCalculator.calculate(invoice);
    final fields = <InvoiceField, ValidationError?>{
      InvoiceField.number: Validators.requiredText(
        invoice.number,
        max: maxNumberLength,
      ),
      InvoiceField.dueDate: invoice.dueDate.isBefore(invoice.issueDate)
          ? ValidationError.dueBeforeIssue
          : null,
      InvoiceField.lines: invoice.lines.isEmpty
          ? ValidationError.noLines
          : null,
      InvoiceField.discount: discountError(invoice.discount, totals.subtotal),
      InvoiceField.tax: Validators.optionalPercent(invoice.taxRateBasisPoints),
      InvoiceField.total: _amountError(totals.total),
    };
    final lines = {
      for (final l in invoice.lines)
        if (validateLine(l, invoice.currencyCode) case final e
            when e.isNotEmpty)
          l.id: e,
    };
    return InvoiceValidation(
      fields: {
        for (final MapEntry(:key, :value) in fields.entries) key: ?value,
      },
      lines: lines,
    );
  }

  static Map<LineField, ValidationError> validateLine(
    LineItem line,
    String currencyCode,
  ) {
    final totals = InvoiceCalculator.line(line, currencyCode);
    final errors = <LineField, ValidationError?>{
      LineField.name: Validators.requiredText(line.name),
      LineField.quantity: line.quantityMilli > 0
          ? null
          : ValidationError.mustBePositive,
      LineField.discount: discountError(line.discount, totals.gross),
      LineField.total: _amountError(totals.gross),
    };
    return {for (final MapEntry(:key, :value) in errors.entries) key: ?value};
  }

  /// A percent above 100% or a flat amount above [base].
  static ValidationError? discountError(Discount? discount, int base) =>
      switch (discount) {
        null => null,
        Discount(type: DiscountType.percent, :final value) =>
          Validators.optionalPercent(value),
        Discount(type: DiscountType.flat, :final value) =>
          value > base ? ValidationError.discountTooLarge : null,
      };

  static ValidationError? _amountError(int minor) =>
      minor.abs() >= Money.maxMinor ? ValidationError.amountTooLarge : null;
}
