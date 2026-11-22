import '../../constants/app_constants.dart';
import '../pdf/pdf_template.dart';
import '../pdf/pdf_template_catalog.dart';

/// What a free account may do. Pro skips every check.
abstract final class FreePlan {
  static bool canAddClient({required bool isPro, required int count}) =>
      isPro || count < AppConstants.freeClientLimit;

  static bool canAddItem({required bool isPro, required int count}) =>
      isPro || count < AppConstants.freeItemLimit;

  static bool canAdd({required bool isPro, required int count}) =>
      isPro || count < AppConstants.freeRecordLimit;

  /// [adUnlockedId] is the one Pro template a free user opened with a
  /// rewarded ad; it stays usable until they pick another template.
  static bool canUse(
    PdfTemplate template, {
    required bool isPro,
    String? adUnlockedId,
  }) => isPro || !template.requiresPro || template.id == adUnlockedId;

  static bool showPdfFooter({required bool isPro}) =>
      AppConstants.freeShowsPdfFooter && !isPro;

  /// How many designs (layout and color pairs) the gallery holds, and how
  /// many of them are free.
  static int get designCount => PdfTemplateCatalog.entries.length;

  static int get freeDesignCount =>
      PdfTemplateCatalog.entries.where((e) => !e.requiresPro).length;
}
