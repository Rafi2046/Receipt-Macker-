import '../../../../core/utils/validation_error.dart';
import '../../../../core/utils/validators.dart';
import '../models/client.dart';
import '../models/client_field.dart';

/// Validates a whole client. Only the name is required.
abstract final class ClientValidator {
  static Map<ClientField, ValidationError> validate(Client c) {
    final errors = <ClientField, ValidationError?>{
      ClientField.name: Validators.requiredText(c.name),
      ClientField.phone: Validators.optionalPhone(c.phone),
      ClientField.email: Validators.optionalEmail(c.email),
      ClientField.address: Validators.optionalText(c.address),
      ClientField.notes: Validators.optionalText(c.notes),
    };
    return {for (final MapEntry(:key, :value) in errors.entries) key: ?value};
  }
}
