import '../../../../core/utils/money.dart';
import '../models/item.dart';
import '../models/item_discount_type.dart';

/// What one item comes to at its default quantity, in minor units.
/// Order: price × quantity (rounded half-up), minus the discount (never
/// more than that), plus tax on the rest.
abstract final class ItemPricing {
  /// Price × default quantity.
  static Money gross(Item item) => Money(
    item.unitPriceMinor,
    item.currencyCode,
  ).timesQuantity(item.defaultQuantityMilli);

  /// The default discount on [gross]: never negative, never above it.
  static Money discount(Item item) {
    final base = gross(item);
    final zero = Money.zero(item.currencyCode);
    final raw = switch (item.discountType) {
      null => zero,
      ItemDiscountType.percent => base.percent(item.discountValue),
      ItemDiscountType.flat => Money(item.discountValue, item.currencyCode),
    };
    return raw.clamp(zero, base);
  }

  /// Gross minus discount, plus the default tax on that.
  static Money amount(Item item) {
    final net = gross(item) - discount(item);
    return net + net.percent(item.defaultTaxBasisPoints ?? 0);
  }
}
