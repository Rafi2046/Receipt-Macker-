import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/app_logger.dart';
import '../purchases/purchase_providers.dart';
import '../service_providers.dart';
import 'ad_presenter.dart';
import 'interstitial_policy.dart';
import 'rewarded_ad_presenter.dart';
import 'running_under_test.dart';

/// Counts a finished share or save, then maybe shows an interstitial.
class ExportAdGate {
  ExportAdGate(this._ref);

  final Ref _ref;

  Future<void> afterSuccessfulExport() async {
    try {
      final prefs = _ref.read(appPreferencesProvider);
      final now = DateTime.now();
      final next = prefs.completedExports + 1;
      await prefs.setCompletedExports(next);
      final show = shouldShowInterstitial(
        isPro: _ref.read(proStatusProvider),
        now: now,
        firstLaunch: _date(prefs.firstLaunchMillis),
        completedExports: next,
        lastShown: _date(prefs.lastInterstitialMillis),
      );
      if (!show) return;
      final shown = await _ref.read(adPresenterProvider).showInterstitial();
      if (!shown) return;
      await prefs.setLastInterstitialMillis(
        DateTime.now().millisecondsSinceEpoch,
      );
    } on Object catch (error, stackTrace) {
      AppLogger.error('export ad', error, stackTrace);
    }
  }

  DateTime? _date(int? millis) =>
      millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
}

final exportAdGateProvider = Provider<ExportAdGate>(ExportAdGate.new);

final adPresenterProvider = Provider<AdPresenter>((ref) {
  if (runningUnderTest) return const NoopAdPresenter();
  final presenter = MobileAdPresenter();
  ref.onDispose(presenter.dispose);
  return presenter;
});

/// Rewarded ads, used to unlock a Pro choice once (a custom color).
final rewardedAdPresenterProvider = Provider<RewardedAdPresenter>((ref) {
  if (runningUnderTest) return const NoopRewardedAdPresenter();
  return MobileRewardedAdPresenter();
});

/// True after the consent form and the Mobile Ads SDK are ready.
final adsReadyProvider = NotifierProvider<AdsReady, bool>(AdsReady.new);

class AdsReady extends Notifier<bool> {
  @override
  bool build() => false;

  void markReady() => state = true;
}
