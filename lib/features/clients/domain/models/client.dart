import 'package:freezed_annotation/freezed_annotation.dart';

part 'client.freezed.dart';

/// Someone the business bills. Invoices keep their own copy of these
/// details, so editing or deleting a client never changes a sent invoice.
@freezed
abstract class Client with _$Client {
  const factory Client({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String phone,
    @Default('') String email,

    /// Billing address line 1 (used on invoices).
    @Default('') String address,
    @Default('') String addressLine2,
    @Default('') String shippingAddress,
    @Default('') String shippingAddressLine2,
    @Default('') String taxRegistrationName,
    @Default('') String taxRegistrationNumber,
    @Default('') String licenseNumber,

    /// Private notes / client detail, never printed.
    @Default('') String notes,
  }) = _Client;
}
