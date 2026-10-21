import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/services/ads/ad_providers.dart';
import '../core/services/ads/running_under_test.dart';
import '../core/services/purchases/purchase_providers.dart';
import '../core/services/service_providers.dart';
import '../core/utils/app_logger.dart';

/// Starts the Play check and AdMob after the first frame. Skipped in tests.
class MonetizationStarter extends ConsumerStatefulWidget {
  const MonetizationStarter({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<MonetizationStarter> createState() =>
      _MonetizationStarterState();
}

class _MonetizationStarterState extends ConsumerState<MonetizationStarter> {
  @override
  void initState() {
    super.initState();
    if (runningUnderTest) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    if (!mounted) return;
    await _rememberLaunch();
    try {
      await ref.read(proStatusProvider.notifier).refreshFromStore();
    } on Object catch (error, stackTrace) {
      AppLogger.error('pro refresh', error, stackTrace);
    }
    if (!mounted) return;
    _prepareAds();
  }

  Future<void> _rememberLaunch() async {
    final prefs = ref.read(appPreferencesProvider);
    if (prefs.firstLaunchMillis != null) return;
    await prefs.setFirstLaunchMillis(DateTime.now().millisecondsSinceEpoch);
  }

  void _prepareAds() {
    try {
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        _afterConsent,
        (_) => _afterConsent(),
      );
    } on Object catch (error, stackTrace) {
      AppLogger.error('consent', error, stackTrace);
    }
  }

  Future<void> _afterConsent() async {
    try {
      await ConsentForm.loadAndShowConsentFormIfRequired((_) {});
      if (!mounted) return;
      if (!await ConsentInformation.instance.canRequestAds()) return;
      await MobileAds.instance.initialize();
      if (!mounted) return;
      ref.read(adsReadyProvider.notifier).markReady();
      await ref.read(adPresenterProvider).preload();
    } on Object catch (error, stackTrace) {
      AppLogger.error('ads', error, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
