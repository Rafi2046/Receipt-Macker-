import '../../../../core/utils/calendar_date.dart';
import '../../../../core/utils/money.dart';
import '../models/bill_to.dart';
import '../models/discount.dart';
import '../models/discount_type.dart';
import '../models/due_term.dart';
import '../models/invoice.dart';
import '../models/invoice_stage.dart';
import '../models/line_item.dart';

/// Pure edits on an invoice draft, used by the invoice editor.
extension InvoiceDrafting on Invoice {
  DueTerm get dueTerm => DueTerm.fromDays(issueDate.daysUntil(dueDate));

  /// Moves the issue date; a preset due term moves the due date with it.
  Invoice withIssueDate(CalendarDate date) {
    final days = dueTerm.days;
    return copyWith(
      issueDate: date,
      dueDate: days == null ? dueDate : date.addDays(days),
    );
  }

  /// Sets the due date from a preset; [DueTerm.custom] keeps it.
  Invoice withDueTerm(DueTerm term) => switch (term.days) {
    null => this,
    final days => copyWith(dueDate: issueDate.addDays(days)),
  };

  Invoice withBillTo({required String clientId, required BillTo billTo}) =>
      copyWith(clientId: clientId, billTo: billTo);

  Invoice withoutBillTo() => copyWith(clientId: null, billTo: null);

  Invoice withLine(LineItem line) => copyWith(lines: [...lines, line]);

  /// Applies [edit] to the line with [id]; other lines are untouched.
  Invoice editLine(String id, LineItem Function(LineItem line) edit) =>
      copyWith(lines: [for (final l in lines) l.id == id ? edit(l) : l]);

  Invoice withoutLine(String id) => copyWith(
    lines: [
      for (final l in lines)
        if (l.id != id) l,
    ],
  );

  /// Switches currency keeping the amounts' face value: ৳500.00 becomes
  /// ¥500 (BDT has 2 decimals, JPY none). Prices, flat discounts and
  /// shipping are rescaled; percentages are unchanged.
  Invoice withCurrency(
    String code, {
    required int fromDecimals,
    required int toDecimals,
  }) {
    int rescale(int minor) => _rescale(minor, fromDecimals, toDecimals);
    Discount? flat(Discount? d) =>
        d?.type == DiscountType.flat ? d?.copyWith(value: rescale(d.value)) : d;
    return copyWith(
      currencyCode: code,
      shippingMinor: rescale(shippingMinor),
      discount: flat(discount),
      lines: [
        for (final l in lines)
          l.copyWith(
            unitPriceMinor: rescale(l.unitPriceMinor),
            discount: flat(l.discount),
          ),
      ],
    );
  }

  /// A new draft from this invoice: new ids and number, dated [today]
  /// with the same payment term, no link to payments.
  Invoice duplicate({
    required String id,
    required String number,
    required CalendarDate today,
    required DateTime now,
    required String Function() newLineId,
  }) => copyWith(
    id: id,
    number: number,
    stage: InvoiceStage.draft,
    issueDate: today,
    dueDate: today.addDays(issueDate.daysUntil(dueDate)),
    lines: [for (final l in lines) l.copyWith(id: newLineId())],
    paidMinor: 0,
    createdAt: now,
    updatedAt: now,
  );

  /// Same content, ignoring timestamps. Used to detect unsaved edits.
  bool sameContentAs(Invoice other) =>
      copyWith(createdAt: other.createdAt, updatedAt: other.updatedAt) == other;
}

int _rescale(int minor, int from, int to) {
  if (from == to) return minor;
  var factor = 1;
  for (var i = 0; i < (from - to).abs(); i++) {
    factor *= 10;
  }
  return to > from ? minor * factor : Money.divideHalfUp(minor, 1, factor);
}
