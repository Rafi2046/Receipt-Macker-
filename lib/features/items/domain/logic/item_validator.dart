import '../../../../core/utils/validation_error.dart';
import '../../../../core/utils/validators.dart';
import '../models/item.dart';
import '../models/item_discount_type.dart';
import '../models/item_field.dart';
import 'item_pricing.dart';

/// Validates a whole item. Name and unit price are required; a price of
/// zero is allowed (free or "price on request" lines). The quantity must
/// be more than zero and a discount no more than price × quantity.
abstract final class ItemValidator {
  static const int maxUnitLength = 20;

  /// [hasPrice] is false while the price field is empty.
  static Map<ItemField, ValidationError> validate(
    Item item, {
    required bool hasPrice,
  }) {
    final errors = <ItemField, ValidationError?>{
      ItemField.name: Validators.requiredText(item.name),
      ItemField.description: Validators.optionalText(item.description),
      ItemField.unit: Validators.optionalText(item.unit, max: maxUnitLength),
      ItemField.unitPrice: Validators.requiredAmount(
        hasPrice ? item.unitPriceMinor : null,
      ),
      ItemField.quantity: item.defaultQuantityMilli > 0
          ? null
          : ValidationError.mustBePositive,
      ItemField.discount: _discountError(item),
      ItemField.defaultTax: Validators.optionalPercent(
        item.defaultTaxBasisPoints,
      ),
    };
    return {for (final MapEntry(:key, :value) in errors.entries) key: ?value};
  }

  static ValidationError? _discountError(Item item) =>
      switch (item.discountType) {
        null => null,
        ItemDiscountType.percent => Validators.optionalPercent(
          item.discountValue,
        ),
        ItemDiscountType.flat =>
          item.discountValue > ItemPricing.gross(item).minor
              ? ValidationError.discountTooLarge
              : null,
      };
}
