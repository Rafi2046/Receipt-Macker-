import '../models/business_profile.dart';
import '../models/profile_field.dart';

/// Reads and writes a profile's text fields by [ProfileField], so forms can
/// be driven by one `updateField` intent.
extension ProfileFieldAccess on BusinessProfile {
  String valueOf(ProfileField field) => switch (field) {
    ProfileField.name => name,
    ProfileField.phone => phone,
    ProfileField.email => email,
    ProfileField.website => website,
    ProfileField.address => address,
    ProfileField.taxId => taxId,
    ProfileField.paymentInstructions => paymentInstructions,
    ProfileField.defaultNotes => defaultNotes,
    ProfileField.defaultTerms => defaultTerms,
  };

  BusinessProfile withField(ProfileField field, String value) =>
      switch (field) {
        ProfileField.name => copyWith(name: value),
        ProfileField.phone => copyWith(phone: value),
        ProfileField.email => copyWith(email: value),
        ProfileField.website => copyWith(website: value),
        ProfileField.address => copyWith(address: value),
        ProfileField.taxId => copyWith(taxId: value),
        ProfileField.paymentInstructions => copyWith(
          paymentInstructions: value,
        ),
        ProfileField.defaultNotes => copyWith(defaultNotes: value),
        ProfileField.defaultTerms => copyWith(defaultTerms: value),
      };

  /// Same content, ignoring timestamps. Used to detect unsaved edits.
  bool sameContentAs(BusinessProfile? other) =>
      other != null &&
      copyWith(updatedAt: other.updatedAt, createdAt: other.createdAt) == other;
}
