import 'package:freezed_annotation/freezed_annotation.dart';

import 'discount_type.dart';

part 'discount.freezed.dart';

/// A discount on a line or on the whole invoice. [value] is basis points
/// for [DiscountType.percent] (1000 = 10%) and minor units of the invoice
/// currency for [DiscountType.flat].
@freezed
abstract class Discount with _$Discount {
  const factory Discount({required DiscountType type, required int value}) =
      _Discount;
}
