import 'package:freezed_annotation/freezed_annotation.dart';

import 'item_discount_type.dart';

part 'item.freezed.dart';

/// A saved product or service. The price is integer minor units of
/// [currencyCode]; [defaultTaxBasisPoints] is null for no tax (1500 = 15%).
/// The quantity and discount are what a new invoice line for it starts
/// with.
@freezed
abstract class Item with _$Item {
  const factory Item({
    required String id,
    required String name,
    required int unitPriceMinor,
    required String currencyCode,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String description,

    /// Free text such as "pcs" or "hour"; empty when not used.
    @Default('') String unit,
    int? defaultTaxBasisPoints,

    /// In thousandths (1500 = 1.5).
    @Default(1000) int defaultQuantityMilli,

    /// Null for no discount.
    ItemDiscountType? discountType,

    /// Basis points for a percentage (1000 = 10%), minor units of
    /// [currencyCode] for a flat amount; unused without a [discountType].
    @Default(0) int discountValue,
  }) = _Item;
}
