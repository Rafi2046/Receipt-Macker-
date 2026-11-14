import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/app_logger.dart';
import '../ads/running_under_test.dart';
import 'firebase_initializer.dart';

/// Non-PII product event analytics interface.
abstract interface class AnalyticsService {
  Future<void> logInvoiceCreated({
    required String templateName,
    required int itemCount,
  });

  Future<void> logInvoiceExported({
    required String templateName,
    required String format,
  });

  Future<void> logPaymentRecorded({
    required String paymentMethod,
    required bool isFullPayment,
  });

  Future<void> logBackupExported();

  Future<void> logProPurchased({required String productId});

  Future<void> logEvent(String name, {Map<String, Object>? parameters});
}

class FirebaseAnalyticsService implements AnalyticsService {
  const FirebaseAnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  @override
  Future<void> logInvoiceCreated({
    required String templateName,
    required int itemCount,
  }) => logEvent(
    'invoice_created',
    parameters: {'template_name': templateName, 'item_count': itemCount},
  );

  @override
  Future<void> logInvoiceExported({
    required String templateName,
    required String format,
  }) => logEvent(
    'invoice_exported',
    parameters: {'template_name': templateName, 'format': format},
  );

  @override
  Future<void> logPaymentRecorded({
    required String paymentMethod,
    required bool isFullPayment,
  }) => logEvent(
    'payment_recorded',
    parameters: {
      'payment_method': paymentMethod,
      'is_full_payment': isFullPayment ? 1 : 0,
    },
  );

  @override
  Future<void> logBackupExported() => logEvent('backup_exported');

  @override
  Future<void> logProPurchased({required String productId}) =>
      logEvent('pro_purchased', parameters: {'product_id': productId});

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } on Object catch (e, s) {
      AppLogger.error('Analytics logEvent failed: $name', e, s);
    }
  }
}

class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  Future<void> logInvoiceCreated({
    required String templateName,
    required int itemCount,
  }) async {}

  @override
  Future<void> logInvoiceExported({
    required String templateName,
    required String format,
  }) async {}

  @override
  Future<void> logPaymentRecorded({
    required String paymentMethod,
    required bool isFullPayment,
  }) async {}

  @override
  Future<void> logBackupExported() async {}

  @override
  Future<void> logProPurchased({required String productId}) async {}

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {}
}

class FakeAnalyticsService implements AnalyticsService {
  final List<(String, Map<String, Object>?)> recordedEvents = [];

  @override
  Future<void> logInvoiceCreated({
    required String templateName,
    required int itemCount,
  }) => logEvent(
    'invoice_created',
    parameters: {'template_name': templateName, 'item_count': itemCount},
  );

  @override
  Future<void> logInvoiceExported({
    required String templateName,
    required String format,
  }) => logEvent(
    'invoice_exported',
    parameters: {'template_name': templateName, 'format': format},
  );

  @override
  Future<void> logPaymentRecorded({
    required String paymentMethod,
    required bool isFullPayment,
  }) => logEvent(
    'payment_recorded',
    parameters: {
      'payment_method': paymentMethod,
      'is_full_payment': isFullPayment ? 1 : 0,
    },
  );

  @override
  Future<void> logBackupExported() => logEvent('backup_exported');

  @override
  Future<void> logProPurchased({required String productId}) =>
      logEvent('pro_purchased', parameters: {'product_id': productId});

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    recordedEvents.add((name, parameters));
  }
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  if (runningUnderTest || !FirebaseInitializer.isInitialized) {
    return const NoopAnalyticsService();
  }
  return FirebaseAnalyticsService(FirebaseAnalytics.instance);
});
