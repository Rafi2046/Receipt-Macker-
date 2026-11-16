import '../../../../core/database/app_database.dart';
import '../../../../core/utils/calendar_date.dart';
import '../../../invoices/domain/models/bill_to.dart';
import '../../../invoices/domain/models/discount.dart';
import '../../../invoices/domain/models/discount_type.dart';
import '../../../invoices/domain/models/line_item.dart';
import '../../domain/models/quote.dart';
import '../../domain/models/quote_status.dart';
import '../../domain/models/quote_summary.dart';

extension QuoteRowMapper on QuoteRow {
  Quote toDomain(List<QuoteLineRow> lineRows) => Quote(
    id: id,
    number: number,
    currencyCode: currencyCode,
    issueDate: CalendarDate.fromKey(issueDate),
    validUntil: CalendarDate.fromKey(validUntil),
    status: _status(status),
    clientId: clientId,
    billTo: switch (billToName) {
      null => null,
      final name => BillTo(
        name: name,
        phone: billToPhone,
        email: billToEmail,
        address: billToAddress,
      ),
    },
    lines: [for (final r in lineRows) r.toDomain()],
    discount: _discount(discountType, discountValue),
    taxRateBasisPoints: taxRateBasisPoints,
    taxInclusive: taxInclusive,
    shippingMinor: shippingMinor,
    notes: notes,
    terms: terms,
    paymentInstructions: paymentInstructions,
    convertedInvoiceId: convertedInvoiceId,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );

  QuoteSummary toSummary() => QuoteSummary(
    id: id,
    number: number,
    currencyCode: currencyCode,
    issueDate: CalendarDate.fromKey(issueDate),
    validUntil: CalendarDate.fromKey(validUntil),
    status: _status(status),
    totalMinor: totalMinor,
    clientName: billToName,
    convertedInvoiceId: convertedInvoiceId,
  );
}

extension QuoteLineRowMapper on QuoteLineRow {
  LineItem toDomain() => LineItem(
    id: id,
    name: name,
    description: description,
    quantityMilli: quantityMilli,
    unit: unit,
    unitPriceMinor: unitPriceMinor,
    discount: _discount(discountType, discountValue),
    itemId: itemId,
  );
}

extension QuoteToRows on Quote {
  QuoteRow toRow({required String profileId, required int totalMinor}) {
    final bill = billTo;
    return QuoteRow(
      id: id,
      profileId: profileId,
      number: number.trim(),
      clientId: clientId,
      billToName: bill?.name.trim(),
      billToPhone: bill?.phone.trim() ?? '',
      billToEmail: bill?.email.trim() ?? '',
      billToAddress: bill?.address.trim() ?? '',
      currencyCode: currencyCode,
      issueDate: issueDate.key,
      validUntil: validUntil.key,
      status: status.name,
      discountType: discount?.type.name,
      discountValue: discount?.value,
      taxRateBasisPoints: taxRateBasisPoints,
      taxInclusive: taxInclusive,
      shippingMinor: shippingMinor,
      totalMinor: totalMinor,
      notes: notes.trim(),
      terms: terms.trim(),
      paymentInstructions: paymentInstructions.trim(),
      convertedInvoiceId: convertedInvoiceId,
      createdAt: createdAt.toUtc(),
      updatedAt: updatedAt.toUtc(),
    );
  }

  List<QuoteLineRow> toLineRows() => [
    for (var i = 0; i < lines.length; i++)
      QuoteLineRow(
        id: lines[i].id,
        quoteId: id,
        position: i,
        itemId: lines[i].itemId,
        name: lines[i].name.trim(),
        description: lines[i].description.trim(),
        quantityMilli: lines[i].quantityMilli,
        unit: lines[i].unit.trim(),
        unitPriceMinor: lines[i].unitPriceMinor,
        discountType: lines[i].discount?.type.name,
        discountValue: lines[i].discount?.value,
      ),
  ];
}

QuoteStatus _status(String raw) => QuoteStatus.values.firstWhere(
  (s) => s.name == raw,
  orElse: () => QuoteStatus.pending,
);

Discount? _discount(String? type, int? value) {
  if (type == null || value == null) return null;
  final parsed = DiscountType.values.where((t) => t.name == type).firstOrNull;
  if (parsed == null) return null;
  return Discount(type: parsed, value: value);
}
