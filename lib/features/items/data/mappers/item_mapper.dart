import '../../../../core/database/app_database.dart';
import '../../domain/models/item.dart';
import '../../domain/models/item_discount_type.dart';

/// Converts between DB rows and the domain model. Dates are stored in UTC.
extension ItemRowMapper on ItemRow {
  Item toDomain() => Item(
    id: id,
    name: name,
    description: description,
    unit: unit,
    unitPriceMinor: unitPriceMinor,
    currencyCode: currencyCode,
    defaultTaxBasisPoints: defaultTaxBasisPoints,
    defaultQuantityMilli: defaultQuantityMilli,
    discountType: ItemDiscountType.values
        .where((t) => t.name == discountType)
        .firstOrNull,
    discountValue: discountValue,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );
}

extension ItemToRow on Item {
  ItemRow toRow() => ItemRow(
    id: id,
    name: name.trim(),
    description: description.trim(),
    unit: unit.trim(),
    unitPriceMinor: unitPriceMinor,
    currencyCode: currencyCode,
    defaultTaxBasisPoints: defaultTaxBasisPoints,
    defaultQuantityMilli: defaultQuantityMilli,
    discountType: discountType?.name,
    discountValue: discountType == null ? 0 : discountValue,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );
}
