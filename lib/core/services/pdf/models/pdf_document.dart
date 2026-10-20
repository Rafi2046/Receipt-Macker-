import 'package:freezed_annotation/freezed_annotation.dart';

import 'pdf_field.dart';
import 'pdf_line.dart';
import 'pdf_party.dart';

part 'pdf_document.freezed.dart';

/// Everything a template prints, already localized and formatted, so
/// templates only lay it out. Used for invoices now and receipts in M6.
@freezed
abstract class PdfDocument with _$PdfDocument {
  const factory PdfDocument({
    /// `en` or `bn`: the HTML language and the page-number digits.
    required String languageCode,

    /// "Invoice", "ইনভয়েস", "Receipt"…
    required String title,
    required String number,
    required PdfParty seller,

    /// Issue date, due date… under the title.
    required List<PdfField> meta,

    /// Table headings: item, quantity, price, amount.
    required List<String> columns,
    required List<PdfLine> lines,

    /// Subtotal, discount, tax, shipping…
    required List<PdfField> totals,

    /// The emphasized amount: total (or balance due).
    required PdfField grandTotal,

    /// "Page {page} of {pages}" split around the two numbers.
    required List<String> pageLabelParts,
    PdfParty? buyer,
    @Default('') String buyerHeading,

    /// Paid / balance rows after the total.
    @Default([]) List<PdfField> afterTotal,

    /// Notes, terms, payment instructions: heading and text.
    @Default([]) List<PdfField> notes,
    String? signatureDataUri,
    @Default('') String signatureLabel,

    /// A short status shown on drafts ("Draft"), or null.
    String? stamp,
  }) = _PdfDocument;
}
