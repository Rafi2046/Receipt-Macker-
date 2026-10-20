import '../../../../core/utils/validation_error.dart';
import '../../../../core/utils/validators.dart';
import '../models/item.dart';
import '../models/item_field.dart';

/// Validates a whole item. Name and unit price are required; a price of
/// zero is allowed (free or "price on request" lines).
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
      ItemField.defaultTax: Validators.optionalPercent(
        item.defaultTaxBasisPoints,
      ),
    };
    return {for (final MapEntry(:key, :value) in errors.entries) key: ?value};
  }
}
