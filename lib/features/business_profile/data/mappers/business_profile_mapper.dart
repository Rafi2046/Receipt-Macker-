import '../../../../core/database/app_database.dart';
import '../../domain/models/business_profile.dart';

/// Converts between DB rows and the domain model. Dates are stored in UTC.
extension BusinessProfileRowMapper on BusinessProfileRow {
  BusinessProfile toDomain() => BusinessProfile(
    id: id,
    name: name,
    address: address,
    phone: phone,
    email: email,
    website: website,
    taxId: taxId,
    paymentInstructions: paymentInstructions,
    defaultNotes: defaultNotes,
    defaultTerms: defaultTerms,
    logoPath: logoPath,
    signaturePath: signaturePath,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );
}

extension BusinessProfileToRow on BusinessProfile {
  BusinessProfileRow toRow() => BusinessProfileRow(
    id: id,
    name: name.trim(),
    address: address.trim(),
    phone: phone.trim(),
    email: email.trim(),
    website: website.trim(),
    taxId: taxId.trim(),
    paymentInstructions: paymentInstructions.trim(),
    defaultNotes: defaultNotes.trim(),
    defaultTerms: defaultTerms.trim(),
    logoPath: logoPath,
    signaturePath: signaturePath,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );
}
