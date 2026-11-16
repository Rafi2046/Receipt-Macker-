import '../../../../core/utils/validation_error.dart';
import '../../../../core/utils/validators.dart';
import '../models/client.dart';
import '../models/client_field.dart';

/// Validates a whole client. Only the name is required.
abstract final class ClientValidator {
  /// Matches the reference "Client Detail" counter.
  static const int maxNotes = 1000;

  static Map<ClientField, ValidationError> validate(Client c) {
    final errors = <ClientField, ValidationError?>{
      ClientField.name: Validators.requiredText(c.name),
      ClientField.phone: Validators.optionalPhone(c.phone),
      ClientField.email: Validators.optionalEmail(c.email),
      ClientField.address: Validators.optionalText(c.address),
      ClientField.addressLine2: Validators.optionalText(c.addressLine2),
      ClientField.shippingAddress: Validators.optionalText(c.shippingAddress),
      ClientField.shippingAddressLine2: Validators.optionalText(
        c.shippingAddressLine2,
      ),
      ClientField.taxRegistrationName: Validators.optionalText(
        c.taxRegistrationName,
        max: Validators.maxShortText,
      ),
      ClientField.taxRegistrationNumber: Validators.optionalText(
        c.taxRegistrationNumber,
        max: Validators.maxShortText,
      ),
      ClientField.licenseNumber: Validators.optionalText(
        c.licenseNumber,
        max: Validators.maxShortText,
      ),
      ClientField.notes: Validators.optionalText(c.notes, max: maxNotes),
    };
    return {for (final MapEntry(:key, :value) in errors.entries) key: ?value};
  }
}
