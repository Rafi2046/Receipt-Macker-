import '../../../invoices/domain/models/invoice.dart';
import '../../../invoices/domain/models/invoice_stage.dart';
import '../models/quote.dart';

/// Maps a quote onto an [Invoice] for the shared calculator / convert flow.
abstract final class QuoteToInvoice {
  static Invoice asInvoice(Quote quote) => Invoice(
    id: quote.id,
    number: quote.number,
    currencyCode: quote.currencyCode,
    issueDate: quote.issueDate,
    dueDate: quote.validUntil,
    createdAt: quote.createdAt,
    updatedAt: quote.updatedAt,
    clientId: quote.clientId,
    billTo: quote.billTo,
    lines: quote.lines,
    discount: quote.discount,
    taxRateBasisPoints: quote.taxRateBasisPoints,
    taxInclusive: quote.taxInclusive,
    shippingMinor: quote.shippingMinor,
    notes: quote.notes,
    terms: quote.terms,
    paymentInstructions: quote.paymentInstructions,
  );

  /// Fresh invoice id/number; keeps commercial content from the quote.
  static Invoice forConversion({
    required Quote quote,
    required String invoiceId,
    required String invoiceNumber,
    required DateTime now,
  }) => asInvoice(quote).copyWith(
    id: invoiceId,
    number: invoiceNumber,
    stage: InvoiceStage.draft,
    paidMinor: 0,
    createdAt: now,
    updatedAt: now,
  );
}
