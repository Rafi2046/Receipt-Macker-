import '../../../../core/database/app_database.dart';
import '../../../../core/utils/calendar_date.dart';
import '../../domain/models/bill_to.dart';
import '../../domain/models/discount.dart';
import '../../domain/models/discount_type.dart';
import '../../domain/models/invoice.dart';
import '../../domain/models/invoice_stage.dart';
import '../../domain/models/invoice_summary.dart';
import '../../domain/models/line_item.dart';

/// Converts between DB rows and domain models. Timestamps are stored in
/// UTC; issue and due dates as `yyyymmdd` calendar days.
extension InvoiceRowMapper on InvoiceRow {
  Invoice toDomain(List<InvoiceLineRow> lineRows) => Invoice(
    id: id,
    number: number,
    currencyCode: currencyCode,
    issueDate: CalendarDate.fromKey(issueDate),
    dueDate: CalendarDate.fromKey(dueDate),
    stage: _stage(stage),
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
    paidMinor: paidMinor,
    notes: notes,
    terms: terms,
    paymentInstructions: paymentInstructions,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );

  InvoiceSummary toSummary() => InvoiceSummary(
    id: id,
    number: number,
    currencyCode: currencyCode,
    issueDate: CalendarDate.fromKey(issueDate),
    dueDate: CalendarDate.fromKey(dueDate),
    stage: _stage(stage),
    totalMinor: totalMinor,
    paidMinor: paidMinor,
    clientName: billToName,
  );
}

extension InvoiceLineRowMapper on InvoiceLineRow {
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

extension InvoiceToRows on Invoice {
  /// Text is trimmed; [totalMinor] comes from the calculator.
  InvoiceRow toRow({required String profileId, required int totalMinor}) {
    final bill = billTo;
    return InvoiceRow(
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
      dueDate: dueDate.key,
      stage: stage.name,
      discountType: discount?.type.name,
      discountValue: discount?.value,
      taxRateBasisPoints: taxRateBasisPoints,
      taxInclusive: taxInclusive,
      shippingMinor: shippingMinor,
      totalMinor: totalMinor,
      paidMinor: paidMinor,
      notes: notes.trim(),
      terms: terms.trim(),
      paymentInstructions: paymentInstructions.trim(),
      createdAt: createdAt.toUtc(),
      updatedAt: updatedAt.toUtc(),
    );
  }

  List<InvoiceLineRow> toLineRows() => [
    for (final (i, l) in lines.indexed)
      InvoiceLineRow(
        id: l.id,
        invoiceId: id,
        position: i,
        itemId: l.itemId,
        name: l.name.trim(),
        description: l.description.trim(),
        quantityMilli: l.quantityMilli,
        unit: l.unit.trim(),
        unitPriceMinor: l.unitPriceMinor,
        discountType: l.discount?.type.name,
        discountValue: l.discount?.value,
      ),
  ];
}

InvoiceStage _stage(String name) =>
    InvoiceStage.values.asNameMap()[name] ?? InvoiceStage.draft;

Discount? _discount(String? type, int? value) =>
    switch ((DiscountType.values.asNameMap()[type], value)) {
      (final DiscountType t, final int v) => Discount(type: t, value: v),
      _ => null,
    };
