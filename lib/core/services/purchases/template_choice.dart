import '../pdf/pdf_template.dart';
import '../preferences/app_preferences.dart';

/// Remembering which PDF template is in use, together with the one-time
/// ad unlock: a Pro template opened with a rewarded ad stays usable only
/// until the user moves to another template.
abstract final class TemplateChoice {
  /// Saves [template] as the one in use; moving away from the ad-unlocked
  /// template ends that unlock.
  static Future<void> remember(
    AppPreferences prefs,
    PdfTemplate template,
  ) async {
    await prefs.setPdfTemplate(template.id);
    final unlocked = prefs.adUnlockedTemplate;
    if (unlocked != null && unlocked != template.id) {
      await prefs.setAdUnlockedTemplate(null);
    }
  }

  /// Marks [template] as opened by a rewarded ad.
  static Future<void> unlockWithAd(
    AppPreferences prefs,
    PdfTemplate template,
  ) => prefs.setAdUnlockedTemplate(template.id);
}
