import '../../../../core/services/pdf/models/pdf_document.dart';
import '../../../../core/services/pdf/models/pdf_field.dart';
import '../../../../core/services/pdf/models/pdf_line.dart';
import '../../../../core/services/pdf/models/pdf_party.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../business_profile/business_profile.dart';
import '../../../invoices/domain/models/invoice.dart';
import '../../../payments/domain/models/payment.dart';
import '../../../payments/domain/models/payment_method.dart';

/// One payment as a printable receipt. Labels and digits follow the PDF
/// language. The table is a single summary row, not the invoice lines.
class ReceiptPdfMapper {
  ReceiptPdfMapper(this.l10n, this.format);

  final AppLocalizations l10n;
  final AppFormatters format;

  static const String _page = '\u0001';
  static const String _pages = '\u0002';

  PdfDocument map({
    required Payment payment,
    required Invoice invoice,
    required int balanceAfter,
    required BusinessProfile seller,
    String? logoDataUri,
    String? signatureDataUri,
  }) {
    final currency = invoice.currencyCode;
    String money(int minor) => format.currency(minor, currency);
    final number = format.localizeDigits(invoice.number);
    final bill = invoice.billTo;
    final note = payment.note.trim();
    return PdfDocument(
      languageCode: format.languageCode,
      title: l10n.pdfReceiptTitle,
      number: format.localizeDigits(payment.receiptNumber),
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
          label: l10n.fieldPaymentDate,
          value: format.calendarDate(payment.paidOn),
        ),
        PdfField(
          label: l10n.fieldPaymentMethod,
          value: _method(payment.method),
        ),
        PdfField(label: l10n.pdfInvoiceTitle, value: number),
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
      buyerHeading: l10n.pdfReceivedFrom,
      columns: [
        l10n.pdfColItem,
        l10n.pdfColQty,
        l10n.pdfColPrice,
        l10n.pdfColAmount,
      ],
      lines: [
        PdfLine(
          name: l10n.pdfPaymentFor(number),
          description: note,
          quantity: '',
          unitPrice: '',
          amount: money(payment.amountMinor),
        ),
      ],
      totals: const [],
      grandTotal: PdfField(
        label: l10n.pdfAmountReceived,
        value: money(payment.amountMinor),
      ),
      afterTotal: [
        PdfField(label: l10n.totalBalance, value: money(balanceAfter)),
      ],
      signatureDataUri: signatureDataUri,
      signatureLabel: l10n.pdfSignature,
      stamp: balanceAfter <= 0 ? l10n.statusPaid : null,
      pageLabelParts: l10n
          .pdfPageOf(_page, _pages)
          .split(RegExp('[$_page$_pages]')),
    );
  }

  String _digits(String text) => format.localizeDigits(text);

  String _method(PaymentMethod method) => switch (method) {
    PaymentMethod.cash => l10n.methodCash,
    PaymentMethod.bkash => l10n.methodBkash,
    PaymentMethod.nagad => l10n.methodNagad,
    PaymentMethod.rocket => l10n.methodRocket,
    PaymentMethod.bankTransfer => l10n.methodBankTransfer,
    PaymentMethod.card => l10n.methodCard,
    PaymentMethod.other => l10n.methodOther,
  };
}
