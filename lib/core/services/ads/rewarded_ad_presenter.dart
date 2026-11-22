import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_ids.dart';

/// Shows a rewarded ad on request. True only when the viewer earned the
/// reward; a load or show failure returns false and never throws.
abstract interface class RewardedAdPresenter {
  Future<bool> showForReward();
}

class NoopRewardedAdPresenter implements RewardedAdPresenter {
  const NoopRewardedAdPresenter({this.rewards = false});

  /// What [showForReward] answers; tests set it to simulate a watched ad.
  final bool rewards;

  @override
  Future<bool> showForReward() async => rewards;
}

class MobileRewardedAdPresenter implements RewardedAdPresenter {
  static const Duration _loadTimeout = Duration(seconds: 12);
  static const Duration _watchTimeout = Duration(minutes: 3);

  @override
  Future<bool> showForReward() async {
    final ad = await _load();
    if (ad == null) return false;
    var earned = false;
    final closed = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (!closed.isCompleted) closed.complete();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        if (!closed.isCompleted) closed.complete();
      },
    );
    await ad.show(onUserEarnedReward: (_, _) => earned = true);
    await closed.future.timeout(_watchTimeout, onTimeout: () {});
    return earned;
  }

  Future<RewardedAd?> _load() {
    final completer = Completer<RewardedAd?>();
    RewardedAd.load(
      adUnitId: AdIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          if (!completer.isCompleted) completer.complete(ad);
        },
        onAdFailedToLoad: (_) {
          if (!completer.isCompleted) completer.complete(null);
        },
      ),
    );
    return completer.future.timeout(_loadTimeout, onTimeout: () => null);
  }
}
