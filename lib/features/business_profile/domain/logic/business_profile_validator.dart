import '../../../../core/utils/validation_error.dart';
import '../../../../core/utils/validators.dart';
import '../models/business_profile.dart';
import '../models/profile_field.dart';

/// Validates a whole profile. Only the business name is required.
abstract final class BusinessProfileValidator {
  static Map<ProfileField, ValidationError> validate(BusinessProfile p) {
    final errors = <ProfileField, ValidationError?>{
      ProfileField.name: Validators.requiredText(p.name),
      ProfileField.phone: Validators.optionalPhone(p.phone),
      ProfileField.email: Validators.optionalEmail(p.email),
      ProfileField.website: Validators.optionalUrl(p.website),
      ProfileField.address: Validators.optionalText(p.address),
      ProfileField.taxId: Validators.optionalText(
        p.taxId,
        max: Validators.maxShortText,
      ),
      ProfileField.paymentInstructions: Validators.optionalText(
        p.paymentInstructions,
      ),
      ProfileField.defaultNotes: Validators.optionalText(p.defaultNotes),
      ProfileField.defaultTerms: Validators.optionalText(p.defaultTerms),
    };
    return {for (final MapEntry(:key, :value) in errors.entries) key: ?value};
  }
}
