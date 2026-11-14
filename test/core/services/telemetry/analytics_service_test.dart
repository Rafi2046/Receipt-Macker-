import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/services/telemetry/analytics_service.dart';
import 'package:receipt_maker/core/services/telemetry/firebase_initializer.dart';

void main() {
  group('FirebaseInitializer & AnalyticsService', () {
    test(
      'FirebaseInitializer returns false safely in test environment',
      () async {
        final initialized = await FirebaseInitializer.initialize();
        expect(initialized, isFalse);
        expect(FirebaseInitializer.isInitialized, isFalse);
      },
    );

    test('analyticsServiceProvider resolves to NoopAnalyticsService when uninitialized', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(analyticsServiceProvider);
      expect(service, isA<NoopAnalyticsService>());
    });

    test(
      'FakeAnalyticsService records product events with non-PII parameters',
      () async {
        final fake = FakeAnalyticsService();

        // 1. invoice_created
        await fake.logInvoiceCreated(templateName: 'classic', itemCount: 3);
        expect(fake.recordedEvents, hasLength(1));
        expect(fake.recordedEvents[0].$1, 'invoice_created');
        expect(fake.recordedEvents[0].$2, {
          'template_name': 'classic',
          'item_count': 3,
        });

        // 2. invoice_exported
        await fake.logInvoiceExported(templateName: 'modern', format: 'pdf');
        expect(fake.recordedEvents, hasLength(2));
        expect(fake.recordedEvents[1].$1, 'invoice_exported');
        expect(fake.recordedEvents[1].$2, {
          'template_name': 'modern',
          'format': 'pdf',
        });

        // 3. payment_recorded
        await fake.logPaymentRecorded(
          paymentMethod: 'cash',
          isFullPayment: true,
        );
        expect(fake.recordedEvents, hasLength(3));
        expect(fake.recordedEvents[2].$1, 'payment_recorded');
        expect(fake.recordedEvents[2].$2, {
          'payment_method': 'cash',
          'is_full_payment': 1,
        });

        // 4. backup_exported
        await fake.logBackupExported();
        expect(fake.recordedEvents, hasLength(4));
        expect(fake.recordedEvents[3].$1, 'backup_exported');
        expect(fake.recordedEvents[3].$2, isNull);

        // 5. pro_purchased
        await fake.logProPurchased(productId: 'quickbill_pro_monthly');
        expect(fake.recordedEvents, hasLength(5));
        expect(fake.recordedEvents[4].$1, 'pro_purchased');
        expect(fake.recordedEvents[4].$2, {
          'product_id': 'quickbill_pro_monthly',
        });
      },
    );

    test('NoopAnalyticsService methods complete without throwing', () async {
      const noop = NoopAnalyticsService();
      await expectLater(
        noop.logInvoiceCreated(templateName: 'classic', itemCount: 1),
        completes,
      );
      await expectLater(
        noop.logInvoiceExported(templateName: 'classic', format: 'pdf'),
        completes,
      );
      await expectLater(
        noop.logPaymentRecorded(paymentMethod: 'bkash', isFullPayment: false),
        completes,
      );
      await expectLater(noop.logBackupExported(), completes);
      await expectLater(
        noop.logProPurchased(productId: 'quickbill_pro_yearly'),
        completes,
      );
      await expectLater(
        noop.logEvent('custom', parameters: {'test': 1}),
        completes,
      );
    });
  });
}
