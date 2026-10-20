import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';

/// A saved product or service. The price is integer minor units of
/// [currencyCode]; [defaultTaxBasisPoints] is null for no tax (1500 = 15%).
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
  }) = _Item;
}
