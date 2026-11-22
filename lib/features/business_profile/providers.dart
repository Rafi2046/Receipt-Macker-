import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database_provider.dart';
import '../../core/services/service_providers.dart';
import 'data/repositories/business_profile_repository_impl.dart';
import 'domain/models/business_profile.dart';
import 'domain/repositories/business_profile_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
BusinessProfileRepository businessProfileRepository(Ref ref) =>
    BusinessProfileRepositoryImpl(
      ref.watch(appDatabaseProvider).businessProfileDao,
      ref.watch(imageStorageServiceProvider),
    );

/// The saved profile, for any screen that shows the seller (home, PDFs).
@riverpod
Stream<BusinessProfile?> currentBusinessProfile(Ref ref) =>
    ref.watch(businessProfileRepositoryProvider).watch();

/// Absolute path of a stored profile image, for `Image.file`.
@riverpod
Future<String> profileImagePath(Ref ref, String relativePath) =>
    ref.watch(businessProfileRepositoryProvider).resolveImagePath(relativePath);

/// The logo's main color as `#RRGGBB`, offered as an invoice accent; null
/// without a logo or when the logo has no clear color.
@riverpod
Future<String?> logoAccentHex(Ref ref) async {
  final profile = await ref.watch(currentBusinessProfileProvider.future);
  final logo = profile?.logoPath;
  if (logo == null || logo.isEmpty) return null;
  final path = await ref.watch(profileImagePathProvider(logo).future);
  return ref.watch(imageColorServiceProvider).dominantHex(path);
}
