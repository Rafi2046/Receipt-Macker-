import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_profile.freezed.dart';

/// The seller shown on every invoice and receipt.
/// Image paths are relative to the app documents directory.
@freezed
abstract class BusinessProfile with _$BusinessProfile {
  const factory BusinessProfile({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String address,
    @Default('') String phone,
    @Default('') String email,
    @Default('') String website,
    @Default('') String taxId,
    @Default('') String paymentInstructions,
    @Default('') String defaultNotes,
    @Default('') String defaultTerms,
    String? logoPath,
    String? signaturePath,
  }) = _BusinessProfile;
}
