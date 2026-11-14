import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/services/ads/ad_ids.dart';

void main() {
  group('AdIds', () {
    test(
      'resolveBanner uses test ID in debug mode regardless of custom ID',
      () {
        expect(
          AdIds.resolveBanner(
            isRelease: false,
            customId: 'ca-app-pub-custom/123',
          ),
          AdIds.testBanner,
        );
        expect(
          AdIds.resolveBanner(isRelease: false, customId: ''),
          AdIds.testBanner,
        );
      },
    );

    test('resolveBanner uses custom ID in release mode when provided', () {
      const custom = 'ca-app-pub-9999999999999999/8888888888';
      expect(AdIds.resolveBanner(isRelease: true, customId: custom), custom);
    });

    test(
      'resolveBanner falls back to test ID in release mode when ID is empty',
      () {
        expect(
          AdIds.resolveBanner(isRelease: true, customId: ''),
          AdIds.testBanner,
        );
      },
    );

    test(
      'resolveInterstitial uses test ID in debug mode regardless of custom ID',
      () {
        expect(
          AdIds.resolveInterstitial(
            isRelease: false,
            customId: 'ca-app-pub-custom/456',
          ),
          AdIds.testInterstitial,
        );
        expect(
          AdIds.resolveInterstitial(isRelease: false, customId: ''),
          AdIds.testInterstitial,
        );
      },
    );

    test(
      'resolveInterstitial uses custom ID in release mode when provided',
      () {
        const custom = 'ca-app-pub-9999999999999999/7777777777';
        expect(
          AdIds.resolveInterstitial(isRelease: true, customId: custom),
          custom,
        );
      },
    );

    test('resolveInterstitial falls back to test ID in release mode when ID is empty', () {
      expect(
        AdIds.resolveInterstitial(isRelease: true, customId: ''),
        AdIds.testInterstitial,
      );
    });
  });
}
