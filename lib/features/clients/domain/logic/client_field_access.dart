import '../models/client.dart';
import '../models/client_field.dart';

/// Reads and writes a client's fields by [ClientField], so the editor can be
/// driven by one `updateField` intent.
extension ClientFieldAccess on Client {
  String valueOf(ClientField field) => switch (field) {
    ClientField.name => name,
    ClientField.phone => phone,
    ClientField.email => email,
    ClientField.address => address,
    ClientField.addressLine2 => addressLine2,
    ClientField.shippingAddress => shippingAddress,
    ClientField.shippingAddressLine2 => shippingAddressLine2,
    ClientField.taxRegistrationName => taxRegistrationName,
    ClientField.taxRegistrationNumber => taxRegistrationNumber,
    ClientField.licenseNumber => licenseNumber,
    ClientField.notes => notes,
  };

  Client withField(ClientField field, String value) => switch (field) {
    ClientField.name => copyWith(name: value),
    ClientField.phone => copyWith(phone: value),
    ClientField.email => copyWith(email: value),
    ClientField.address => copyWith(address: value),
    ClientField.addressLine2 => copyWith(addressLine2: value),
    ClientField.shippingAddress => copyWith(shippingAddress: value),
    ClientField.shippingAddressLine2 => copyWith(shippingAddressLine2: value),
    ClientField.taxRegistrationName => copyWith(taxRegistrationName: value),
    ClientField.taxRegistrationNumber => copyWith(taxRegistrationNumber: value),
    ClientField.licenseNumber => copyWith(licenseNumber: value),
    ClientField.notes => copyWith(notes: value),
  };

  /// Same content, ignoring timestamps. Used to detect unsaved edits.
  bool sameContentAs(Client other) =>
      copyWith(createdAt: other.createdAt, updatedAt: other.updatedAt) == other;

  /// True when any secondary (show-more) field has content.
  bool get hasSecondaryDetails =>
      addressLine2.isNotEmpty ||
      shippingAddress.isNotEmpty ||
      shippingAddressLine2.isNotEmpty ||
      taxRegistrationName.isNotEmpty ||
      taxRegistrationNumber.isNotEmpty ||
      licenseNumber.isNotEmpty ||
      notes.isNotEmpty;
}
