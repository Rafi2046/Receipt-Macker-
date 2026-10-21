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

  static String get banner =>
      kReleaseMode && _banner.isNotEmpty ? _banner : testBanner;

  static String get interstitial => kReleaseMode && _interstitial.isNotEmpty
      ? _interstitial
      : testInterstitial;
}
