import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/constants/app_constants.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template.dart';
import 'package:receipt_maker/core/services/purchases/free_plan.dart';

void main() {
  group('FreePlan', () {
    test('canAddClient limits free tier to 10 clients', () {
      expect(AppConstants.freeClientLimit, 10);

      // Free user
      expect(FreePlan.canAddClient(isPro: false, count: 0), isTrue);
      expect(FreePlan.canAddClient(isPro: false, count: 9), isTrue);
      expect(FreePlan.canAddClient(isPro: false, count: 10), isFalse);
      expect(FreePlan.canAddClient(isPro: false, count: 15), isFalse);

      // Pro user (unlimited)
      expect(FreePlan.canAddClient(isPro: true, count: 0), isTrue);
      expect(FreePlan.canAddClient(isPro: true, count: 10), isTrue);
      expect(FreePlan.canAddClient(isPro: true, count: 100), isTrue);
    });

    test('canAddItem limits free tier to 20 items', () {
      expect(AppConstants.freeItemLimit, 20);

      // Free user
      expect(FreePlan.canAddItem(isPro: false, count: 0), isTrue);
      expect(FreePlan.canAddItem(isPro: false, count: 19), isTrue);
      expect(FreePlan.canAddItem(isPro: false, count: 20), isFalse);
      expect(FreePlan.canAddItem(isPro: false, count: 50), isFalse);

      // Pro user (unlimited)
      expect(FreePlan.canAddItem(isPro: true, count: 0), isTrue);
      expect(FreePlan.canAddItem(isPro: true, count: 20), isTrue);
      expect(FreePlan.canAddItem(isPro: true, count: 200), isTrue);
    });

    test('canUse gates every layout but the three free ones', () {
      expect(PdfTemplate.freeLayouts, {
        PdfTemplate.classic,
        PdfTemplate.minimal,
        PdfTemplate.compact,
      });

      // Free user
      for (final t in PdfTemplate.values) {
        final free = PdfTemplate.freeLayouts.contains(t);
        expect(t.requiresPro, !free, reason: t.id);
        expect(FreePlan.canUse(t, isPro: false), free, reason: t.id);
      }

      // Pro user
      for (final t in PdfTemplate.values) {
        expect(FreePlan.canUse(t, isPro: true), isTrue, reason: t.id);
      }
    });

    test('showPdfFooter is true for Free and false for Pro', () {
      expect(FreePlan.showPdfFooter(isPro: false), isTrue);
      expect(FreePlan.showPdfFooter(isPro: true), isFalse);
    });
  });
}
