import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_ids.dart';

/// Shows an interstitial when one is loaded. A failure never throws.
abstract interface class AdPresenter {
  Future<void> preload();
  Future<bool> showInterstitial();
}

class NoopAdPresenter implements AdPresenter {
  const NoopAdPresenter();

  @override
  Future<void> preload() async {}

  @override
  Future<bool> showInterstitial() async => false;
}

class MobileAdPresenter implements AdPresenter {
  InterstitialAd? _ready;
  Completer<InterstitialAd?>? _loading;

  void dispose() {
    _ready?.dispose();
    _ready = null;
  }

  @override
  Future<void> preload() async {
    await _load();
  }

  @override
  Future<bool> showInterstitial() async {
    final ad = await _load();
    if (ad == null) return false;
    final shown = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (!shown.isCompleted) shown.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        if (!shown.isCompleted) shown.complete(false);
      },
    );
    _ready = null;
    await ad.show();
    final ok = await shown.future.timeout(
      const Duration(minutes: 2),
      onTimeout: () => false,
    );
    await preload();
    return ok;
  }

  Future<InterstitialAd?> _load() {
    final ready = _ready;
    if (ready != null) return Future.value(ready);
    final pending = _loading;
    if (pending != null) return pending.future;
    final completer = Completer<InterstitialAd?>();
    _loading = completer;
    InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ready = ad;
          _loading = null;
          if (!completer.isCompleted) completer.complete(ad);
        },
        onAdFailedToLoad: (_) {
          _loading = null;
          if (!completer.isCompleted) completer.complete(null);
        },
      ),
    );
    return completer.future.timeout(
      const Duration(seconds: 4),
      onTimeout: () => null,
    );
  }
}
