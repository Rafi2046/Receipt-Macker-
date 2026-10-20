import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/validation_error.dart';
import 'package:receipt_maker/features/items/domain/logic/item_content.dart';
import 'package:receipt_maker/features/items/domain/logic/item_validator.dart';
import 'package:receipt_maker/features/items/domain/models/item.dart';
import 'package:receipt_maker/features/items/domain/models/item_field.dart';

void main() {
  final t = DateTime.utc(2026, 10, 20);
  final blank = Item(
    id: 'i',
    name: '',
    unitPriceMinor: 0,
    currencyCode: 'BDT',
    createdAt: t,
    updatedAt: t,
  );

  test('name and price are required; zero price is fine', () {
    expect(ItemValidator.validate(blank, hasPrice: false), {
      ItemField.name: ValidationError.required,
      ItemField.unitPrice: ValidationError.required,
    });
    expect(
      ItemValidator.validate(blank.copyWith(name: 'Pen'), hasPrice: true),
      isEmpty,
    );
  });

  test('tax above 100% and long units are rejected', () {
    final item = blank.copyWith(
      name: 'Pen',
      unit: 'x' * (ItemValidator.maxUnitLength + 1),
      defaultTaxBasisPoints: 10001,
    );
    expect(ItemValidator.validate(item, hasPrice: true), {
      ItemField.unit: ValidationError.tooLong,
      ItemField.defaultTax: ValidationError.percentTooHigh,
    });
  });

  test('sameContentAs ignores timestamps', () {
    final later = blank.copyWith(updatedAt: t.add(const Duration(days: 1)));
    expect(later.sameContentAs(blank), isTrue);
    expect(blank.copyWith(unitPriceMinor: 1).sameContentAs(blank), isFalse);
  });
}
