import '../../constants/app_constants.dart';
import '../pdf/pdf_template.dart';

/// What a free account may do. Pro skips every check.
abstract final class FreePlan {
  static bool canAddClient({required bool isPro, required int count}) =>
      isPro || count < AppConstants.freeClientLimit;

  static bool canAddItem({required bool isPro, required int count}) =>
      isPro || count < AppConstants.freeItemLimit;

  static bool canAdd({required bool isPro, required int count}) =>
      isPro || count < AppConstants.freeRecordLimit;

  static bool canUse(PdfTemplate template, {required bool isPro}) =>
      isPro || !template.requiresPro;

  static bool showPdfFooter({required bool isPro}) =>
      AppConstants.freeShowsPdfFooter && !isPro;

  /// How many PDF templates exist, and how many of them are free.
  static int get templateCount => PdfTemplate.values.length;

  static int get freeTemplateCount =>
      PdfTemplate.values.where((t) => !t.requiresPro).length;
}
