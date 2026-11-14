import 'package:flutter/foundation.dart';

/// Ad unit ids. Debug builds always use Google's test ids.
/// Release reads `--dart-define=ADMOB_BANNER_ID` and `ADMOB_INTERSTITIAL_ID`.
abstract final class AdIds {
  static const String testBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitial =
      'ca-app-pub-3940256099942544/1033173712';

  static const String _banner = String.fromEnvironment('ADMOB_BANNER_ID');
  static const String _interstitial = String.fromEnvironment(
    'ADMOB_INTERSTITIAL_ID',
  );

  static String get banner => resolveBanner(isRelease: kReleaseMode);

  static String get interstitial =>
      resolveInterstitial(isRelease: kReleaseMode);

  /// Resolves banner unit ID, falling back to test ID in debug or if unset.
  static String resolveBanner({required bool isRelease, String? customId}) {
    final candidate = customId ?? _banner;
    return isRelease && candidate.isNotEmpty ? candidate : testBanner;
  }

  /// Resolves interstitial unit ID, falling back to test ID in debug or if unset.
  static String resolveInterstitial({
    required bool isRelease,
    String? customId,
  }) {
    final candidate = customId ?? _interstitial;
    return isRelease && candidate.isNotEmpty ? candidate : testInterstitial;
  }
}
