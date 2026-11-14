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

    test('canUse template gates Modern and Minimal behind Pro', () {
      expect(PdfTemplate.classic.requiresPro, isFalse);
      expect(PdfTemplate.modern.requiresPro, isTrue);
      expect(PdfTemplate.minimal.requiresPro, isTrue);

      // Free user
      expect(FreePlan.canUse(PdfTemplate.classic, isPro: false), isTrue);
      expect(FreePlan.canUse(PdfTemplate.modern, isPro: false), isFalse);
      expect(FreePlan.canUse(PdfTemplate.minimal, isPro: false), isFalse);

      // Pro user
      expect(FreePlan.canUse(PdfTemplate.classic, isPro: true), isTrue);
      expect(FreePlan.canUse(PdfTemplate.modern, isPro: true), isTrue);
      expect(FreePlan.canUse(PdfTemplate.minimal, isPro: true), isTrue);
    });

    test('showPdfFooter is true for Free and false for Pro', () {
      expect(FreePlan.showPdfFooter(isPro: false), isTrue);
      expect(FreePlan.showPdfFooter(isPro: true), isFalse);
    });
  });
}
