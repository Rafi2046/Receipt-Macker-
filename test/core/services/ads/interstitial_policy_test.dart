import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/constants/app_constants.dart';
import 'package:receipt_maker/core/services/ads/interstitial_policy.dart';

void main() {
  final dayOne = DateTime(2026, 10, 21, 9);
  final later = dayOne.add(const Duration(days: 2));

  test('skips Pro, the first day, and exports that are not every fifth', () {
    expect(
      shouldShowInterstitial(
        isPro: true,
        now: later,
        firstLaunch: dayOne,
        completedExports: 5,
        lastShown: null,
      ),
      isFalse,
    );
    expect(
      shouldShowInterstitial(
        isPro: false,
        now: dayOne.add(const Duration(hours: 3)),
        firstLaunch: dayOne,
        completedExports: 5,
        lastShown: null,
      ),
      isFalse,
    );
    expect(
      shouldShowInterstitial(
        isPro: false,
        now: later,
        firstLaunch: dayOne,
        completedExports: 4,
        lastShown: null,
      ),
      isFalse,
    );
  });

  test('shows on the fifth export after day one, then waits', () {
    expect(
      shouldShowInterstitial(
        isPro: false,
        now: later,
        firstLaunch: dayOne,
        completedExports: AppConstants.interstitialEveryNExports,
        lastShown: null,
      ),
      isTrue,
    );
    expect(
      shouldShowInterstitial(
        isPro: false,
        now: later,
        firstLaunch: dayOne,
        completedExports: 10,
        lastShown: later.subtract(const Duration(minutes: 1)),
      ),
      isFalse,
    );
    expect(
      shouldShowInterstitial(
        isPro: false,
        now: later,
        firstLaunch: dayOne,
        completedExports: 10,
        lastShown: later.subtract(const Duration(minutes: 4)),
      ),
      isTrue,
    );
  });
}
