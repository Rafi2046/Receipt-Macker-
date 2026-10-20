import '../../../../core/services/pdf/models/pdf_document.dart';
import '../../../../core/services/pdf/models/pdf_field.dart';
import '../../../../core/services/pdf/models/pdf_line.dart';
import '../../../../core/services/pdf/models/pdf_party.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../business_profile/business_profile.dart';
import '../../domain/models/discount.dart';
import '../../domain/models/discount_type.dart';
import '../../domain/models/invoice.dart';
import '../../domain/models/invoice_totals.dart';

/// Builds the printable document of an invoice: every label in the PDF's
/// language and every number, date and amount formatted for it.
class InvoicePdfMapper {
  InvoicePdfMapper(this.l10n, this.format);

  final AppLocalizations l10n;
  final AppFormatters format;

  /// Placeholders swapped for page counters by the template CSS.
  static const String _page = '\u0001';
  static const String _pages = '\u0002';

  PdfDocument map({
    required Invoice invoice,
    required InvoiceTotals totals,
    required BusinessProfile seller,
    String? logoDataUri,
    String? signatureDataUri,
  }) {
    final currency = invoice.currencyCode;
    String money(int minor) => format.currency(minor, currency);
    final bill = invoice.billTo;
    return PdfDocument(
      languageCode: format.languageCode,
      title: l10n.pdfInvoiceTitle,
      number: format.localizeDigits(invoice.number),
      seller: PdfParty(
        name: seller.name,
        logoDataUri: logoDataUri,
        lines: [
          seller.address,
          _digits([seller.phone, seller.email].join('   ')),
          seller.website,
          if (seller.taxId.trim().isNotEmpty)
            l10n.pdfTaxId(format.localizeDigits(seller.taxId)),
        ],
      ),
      meta: [
        PdfField(
          label: l10n.fieldIssueDate,
          value: format.calendarDate(invoice.issueDate),
        ),
        PdfField(
          label: l10n.fieldDueDate,
          value: format.calendarDate(invoice.dueDate),
        ),
      ],
      buyer: bill == null
          ? null
          : PdfParty(
              name: bill.name,
              lines: [
                bill.address,
                _digits([bill.phone, bill.email].join('   ')),
              ],
            ),
      buyerHeading: l10n.sectionBillTo,
      columns: [
        l10n.pdfColItem,
        l10n.pdfColQty,
        l10n.pdfColPrice,
        l10n.pdfColAmount,
      ],
      lines: [
        for (final (i, line) in invoice.lines.indexed)
          PdfLine(
            name: line.name,
            description: line.description,
            quantity: [
              format.quantity(line.quantityMilli),
              if (line.unit.isNotEmpty) line.unit,
            ].join(' '),
            unitPrice: money(line.unitPriceMinor),
            amount: money(totals.lines[i].net),
            discountNote: _discountNote(line.discount, currency),
          ),
      ],
      totals: _totals(invoice, totals, money),
      grandTotal: PdfField(label: l10n.totalTotal, value: money(totals.total)),
      afterTotal: totals.paid == 0
          ? const []
          : [
              PdfField(label: l10n.totalPaid, value: money(-totals.paid)),
              PdfField(label: l10n.totalBalance, value: money(totals.balance)),
            ],
      notes: [
        for (final (label, text) in [
          (l10n.fieldNotes, invoice.notes),
          (l10n.fieldTerms, invoice.terms),
          (l10n.fieldPaymentInstructions, invoice.paymentInstructions),
        ])
          if (text.trim().isNotEmpty)
            PdfField(label: label, value: _digits(text)),
      ],
      signatureDataUri: signatureDataUri,
      signatureLabel: l10n.pdfSignature,
      pageLabelParts: l10n
          .pdfPageOf(_page, _pages)
          .split(RegExp('[$_page$_pages]')),
    );
  }

  List<PdfField> _totals(
    Invoice invoice,
    InvoiceTotals t,
    String Function(int) money,
  ) {
    final rate = invoice.taxRateBasisPoints;
    final rateText = rate == null ? '' : format.percent(rate);
    return [
      PdfField(label: l10n.totalSubtotal, value: money(t.subtotal)),
      if (t.discount != 0)
        PdfField(label: l10n.totalDiscount, value: money(-t.discount)),
      if (t.tax != 0)
        PdfField(
          label: invoice.taxInclusive
              ? l10n.totalTaxIncluded(rateText)
              : l10n.totalTax(rateText),
          value: money(t.tax),
        ),
      if (t.shipping != 0)
        PdfField(label: l10n.totalShipping, value: money(t.shipping)),
    ];
  }

  String? _discountNote(Discount? d, String currency) => switch (d) {
    null || Discount(value: 0) => null,
    Discount(type: DiscountType.percent, :final value) => l10n.pdfLineDiscount(
      format.percent(value),
    ),
    Discount(type: DiscountType.flat, :final value) => l10n.pdfLineDiscount(
      format.currency(value, currency),
    ),
  };

  /// Phone numbers and other typed digits follow the PDF's language.
  String _digits(String text) => format.localizeDigits(text.trim());
}
