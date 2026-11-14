import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../utils/app_logger.dart';
import '../purchases/purchase_providers.dart';
import 'running_under_test.dart';

/// UMP consent service for gathering and managing user ad consent.
abstract interface class ConsentService {
  Future<bool> isPrivacyOptionsRequired();
  Future<void> showPrivacyOptionsForm();
}

class UmpConsentService implements ConsentService {
  const UmpConsentService();

  @override
  Future<bool> isPrivacyOptionsRequired() async {
    if (runningUnderTest) return false;
    try {
      final status = await ConsentInformation.instance
          .getPrivacyOptionsRequirementStatus();
      return status == PrivacyOptionsRequirementStatus.required;
    } on Object catch (error, stackTrace) {
      AppLogger.error('getPrivacyOptionsRequirementStatus', error, stackTrace);
      return false;
    }
  }

  @override
  Future<void> showPrivacyOptionsForm() async {
    if (runningUnderTest) return;
    final completer = Completer<void>();
    try {
      await ConsentForm.showPrivacyOptionsForm((FormError? error) {
        if (error != null) {
          AppLogger.error('showPrivacyOptionsForm: ${error.message}');
        }
        if (!completer.isCompleted) completer.complete();
      });
    } on Object catch (error, stackTrace) {
      AppLogger.error('showPrivacyOptionsForm', error, stackTrace);
      if (!completer.isCompleted) completer.complete();
    }
    return completer.future;
  }
}

class FakeConsentService implements ConsentService {
  FakeConsentService({this.required = false});

  bool required;
  bool formShown = false;

  @override
  Future<bool> isPrivacyOptionsRequired() async => required;

  @override
  Future<void> showPrivacyOptionsForm() async {
    formShown = true;
  }
}

final consentServiceProvider = Provider<ConsentService>((ref) {
  if (runningUnderTest) return FakeConsentService();
  return const UmpConsentService();
});

final privacyOptionsRequiredProvider = FutureProvider.autoDispose<bool>((
  ref,
) async {
  final isPro = ref.watch(proStatusProvider);
  if (isPro) return false;
  final service = ref.watch(consentServiceProvider);
  return service.isPrivacyOptionsRequired();
});
