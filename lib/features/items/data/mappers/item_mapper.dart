import '../../../../core/database/app_database.dart';
import '../../domain/models/item.dart';

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
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );
}
