import '../../../../core/database/app_database.dart';
import '../../../../core/utils/money_input_parser.dart';
import '../../domain/models/client.dart';

/// Converts between DB rows and the domain model. Dates are stored in UTC.
extension ClientRowMapper on ClientRow {
  Client toDomain() => Client(
    id: id,
    name: name,
    phone: phone,
    email: email,
    address: address,
    addressLine2: addressLine2,
    shippingAddress: shippingAddress,
    shippingAddressLine2: shippingAddressLine2,
    taxRegistrationName: taxRegistrationName,
    taxRegistrationNumber: taxRegistrationNumber,
    licenseNumber: licenseNumber,
    notes: notes,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );
}

extension ClientToRow on Client {
  /// Trims text and stores phone digits in Latin form, so a number typed
  /// with Bangla digits is found by either kind of search.
  ClientRow toRow() => ClientRow(
    id: id,
    name: name.trim(),
    phone: MoneyInputParser.normalize(phone.trim()),
    email: email.trim(),
    address: address.trim(),
    addressLine2: addressLine2.trim(),
    shippingAddress: shippingAddress.trim(),
    shippingAddressLine2: shippingAddressLine2.trim(),
    taxRegistrationName: taxRegistrationName.trim(),
    taxRegistrationNumber: taxRegistrationNumber.trim(),
    licenseNumber: licenseNumber.trim(),
    notes: notes.trim(),
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );
}
