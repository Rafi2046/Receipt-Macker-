import '../../../../core/utils/money.dart';
import '../models/discount.dart';
import '../models/discount_type.dart';
import '../models/invoice.dart';
import '../models/invoice_totals.dart';
import '../models/line_item.dart';

/// Works out every amount on an invoice in integer minor units.
///
/// Order, rounding half-up at each step:
/// 1. Line gross = unit price × quantity.
/// 2. Line discount: a percent of the gross, or a flat amount (never more
///    than the gross). Line net = gross − discount.
/// 3. Subtotal = sum of line nets.
/// 4. Invoice discount: a percent of the subtotal, or a flat amount (never
///    more than the subtotal). Taxable amount = subtotal − discount.
/// 5. Tax on the taxable amount. Exclusive: tax = amount × rate, added on
///    top. Inclusive: the amount already contains the tax, so
///    tax = amount − amount ÷ (1 + rate), and nothing is added.
/// 6. Total = taxable amount (+ tax when exclusive) + shipping. Shipping is
///    not taxed.
/// 7. Balance = total − paid.
abstract final class InvoiceCalculator {
  static InvoiceTotals calculate(Invoice invoice, {int paidMinor = 0}) {
    final currency = invoice.currencyCode;
    final lines = [for (final l in invoice.lines) line(l, currency)];
    final subtotal = Money(
      lines.fold(0, (sum, l) => _cap(sum + l.net)),
      currency,
    );
    final discount = discountOn(subtotal, invoice.discount);
    final taxable = subtotal - discount;
    final tax = taxOn(
      taxable,
      invoice.taxRateBasisPoints ?? 0,
      inclusive: invoice.taxInclusive,
    );
    final shipping = Money(invoice.shippingMinor, currency);
    final total = invoice.taxInclusive
        ? taxable + shipping
        : taxable + tax + shipping;
    final totalMinor = _cap(total.minor);
    return InvoiceTotals(
      currencyCode: currency,
      lines: lines,
      subtotal: subtotal.minor,
      discount: discount.minor,
      tax: tax.minor,
      shipping: shipping.minor,
      total: totalMinor,
      paid: paidMinor,
      balance: totalMinor - paidMinor,
    );
  }

  static LineTotals line(LineItem line, String currencyCode) {
    final gross = Money(
      line.unitPriceMinor,
      currencyCode,
    ).timesQuantity(line.quantityMilli);
    final discount = discountOn(gross, line.discount);
    return LineTotals(
      gross: gross.minor,
      discount: discount.minor,
      net: (gross - discount).minor,
    );
  }

  /// The discount on [base]: never negative and never more than [base].
  static Money discountOn(Money base, Discount? discount) {
    if (discount == null) return Money.zero(base.currencyCode);
    final raw = switch (discount.type) {
      DiscountType.percent => base.percent(discount.value),
      DiscountType.flat => Money(discount.value, base.currencyCode),
    };
    return raw.clamp(Money.zero(base.currencyCode), base);
  }

  /// Tax at [basisPoints] on [amount]; see step 5 in the class comment.
  static Money taxOn(Money amount, int basisPoints, {required bool inclusive}) {
    if (basisPoints <= 0) return Money.zero(amount.currencyCode);
    if (!inclusive) return amount.percent(basisPoints);
    final net = amount.scale(
      Money.basisPointsPerWhole,
      Money.basisPointsPerWhole + basisPoints,
    );
    return amount - net;
  }

  /// Keeps sums within the supported range (see [Money.maxMinor]).
  static int _cap(int minor) => minor.clamp(-Money.maxMinor, Money.maxMinor);
}
