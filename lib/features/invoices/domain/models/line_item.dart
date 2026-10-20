import 'package:freezed_annotation/freezed_annotation.dart';

import 'discount.dart';

part 'line_item.freezed.dart';

/// One line on an invoice. [quantityMilli] is in thousandths (1500 = 1.5);
/// [unitPriceMinor] is in minor units of the invoice currency.
@freezed
abstract class LineItem with _$LineItem {
  const factory LineItem({
    required String id,
    required String name,
    @Default(1000) int quantityMilli,
    @Default(0) int unitPriceMinor,
    @Default('') String description,
    @Default('') String unit,
    Discount? discount,

    /// The saved item this line came from, if any.
    String? itemId,
  }) = _LineItem;
}
