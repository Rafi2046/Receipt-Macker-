import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_to.freezed.dart';

/// The buyer's details as printed on this invoice. Copied from the client
/// when picked, so later edits to the client never change the invoice.
@freezed
abstract class BillTo with _$BillTo {
  const factory BillTo({
    required String name,
    @Default('') String phone,
    @Default('') String email,
    @Default('') String address,
  }) = _BillTo;
}
