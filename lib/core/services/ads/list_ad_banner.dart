import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../purchases/purchase_providers.dart';
import 'ad_ids.dart';
import 'ad_providers.dart';
import 'running_under_test.dart';

/// Banner for the invoice, client and item lists. Hidden for Pro, in tests,
/// and when the ad fails to load.
class ListAdBanner extends ConsumerStatefulWidget {
  const ListAdBanner({super.key});

  @override
  ConsumerState<ListAdBanner> createState() => _ListAdBannerState();
}

class _ListAdBannerState extends ConsumerState<ListAdBanner> {
  BannerAd? _ad;
  var _loaded = false;
  var _started = false;

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  void _load() {
    if (_started || !mounted || runningUnderTest) return;
    if (ref.read(proStatusProvider) || !ref.read(adsReadyProvider)) return;
    _started = true;
    final ad = BannerAd(
      adUnitId: AdIds.banner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _ad = null;
            _loaded = false;
          });
        },
      ),
    );
    _ad = ad;
    ad.load();
  }

  void _drop() {
    _ad?.dispose();
    _ad = null;
    _loaded = false;
    _started = false;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(adsReadyProvider, (previous, next) {
      if (next) _load();
    });
    ref.listen(proStatusProvider, (previous, next) {
      if (next && _ad != null) setState(_drop);
    });
    if (ref.watch(adsReadyProvider) && !_started) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
    final ad = _ad;
    if (ref.watch(proStatusProvider) || ad == null || !_loaded) {
      return const SizedBox.shrink();
    }
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: SizedBox(
          width: ad.size.width.toDouble(),
          height: ad.size.height.toDouble(),
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }
}
