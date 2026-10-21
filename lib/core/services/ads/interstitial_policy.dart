import '../../constants/app_constants.dart';

/// Whether a completed export may show an interstitial. Pure: no plugin.
bool shouldShowInterstitial({
  required bool isPro,
  required DateTime now,
  required DateTime? firstLaunch,
  required int completedExports,
  required DateTime? lastShown,
}) {
  if (isPro) return false;
  final start = firstLaunch ?? now;
  if (AppConstants.interstitialSkipFirstDay &&
      now.difference(start) < const Duration(days: 1)) {
    return false;
  }
  if (completedExports <= 0 ||
      completedExports % AppConstants.interstitialEveryNExports != 0) {
    return false;
  }
  if (lastShown != null &&
      now.difference(lastShown) < AppConstants.interstitialMinInterval) {
    return false;
  }
  return true;
}
