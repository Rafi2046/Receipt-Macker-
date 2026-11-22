import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/validation_error.dart';
import 'package:receipt_maker/features/items/domain/logic/item_pricing.dart';
import 'package:receipt_maker/features/items/domain/logic/item_validator.dart';
import 'package:receipt_maker/features/items/domain/models/item.dart';
import 'package:receipt_maker/features/items/domain/models/item_discount_type.dart';
import 'package:receipt_maker/features/items/domain/models/item_field.dart';

void main() {
  final t = DateTime.utc(2026, 10, 20);
  Item item({
    int price = 10000,
    String currency = 'BDT',
    int quantityMilli = 1000,
    ItemDiscountType? discountType,
    int discountValue = 0,
    int? tax,
  }) => Item(
    id: 'i',
    name: 'Logo',
    unitPriceMinor: price,
    currencyCode: currency,
    defaultQuantityMilli: quantityMilli,
    discountType: discountType,
    discountValue: discountValue,
    defaultTaxBasisPoints: tax,
    createdAt: t,
    updatedAt: t,
  );

  test('amount is price times quantity when nothing else is set', () {
    expect(ItemPricing.amount(item()).minor, 10000);
    expect(ItemPricing.amount(item(quantityMilli: 2500)).minor, 25000);
  });

  test('a percentage discount comes off before tax is added', () {
    final i = item(
      quantityMilli: 2000,
      discountType: ItemDiscountType.percent,
      discountValue: 1000,
      tax: 1500,
    );
    expect(ItemPricing.gross(i).minor, 20000);
    expect(ItemPricing.discount(i).minor, 2000);
    // 18,000 + 15% = 20,700.
    expect(ItemPricing.amount(i).minor, 20700);
  });

  test('a flat discount never takes the amount below zero', () {
    final i = item(discountType: ItemDiscountType.flat, discountValue: 99999);
    expect(ItemPricing.discount(i).minor, 10000);
    expect(ItemPricing.amount(i).minor, 0);
  });

  test('rounds half-up and works for zero-decimal currencies', () {
    // ¥333 × 1.5 = 499.5 → 500; 8% tax on 500 = 40.
    final i = item(price: 333, currency: 'JPY', quantityMilli: 1500, tax: 800);
    expect(ItemPricing.gross(i).minor, 500);
    expect(ItemPricing.amount(i).minor, 540);
  });

  test('quantity must be positive; discounts must fit', () {
    Map<ItemField, ValidationError> errors(Item i) =>
        ItemValidator.validate(i, hasPrice: true);
    expect(errors(item()), isEmpty);
    expect(
      errors(item(quantityMilli: 0))[ItemField.quantity],
      ValidationError.mustBePositive,
    );
    expect(
      errors(
        item(discountType: ItemDiscountType.percent, discountValue: 10001),
      )[ItemField.discount],
      ValidationError.percentTooHigh,
    );
    expect(
      errors(
        item(discountType: ItemDiscountType.flat, discountValue: 10001),
      )[ItemField.discount],
      ValidationError.discountTooLarge,
    );
    expect(
      errors(item(discountType: ItemDiscountType.flat, discountValue: 10000)),
      isEmpty,
    );
  });
}
