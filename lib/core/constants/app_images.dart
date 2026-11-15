/// Asset paths for images. Files are added as the features need them.
/// The logo is generated from assets/branding/quickbill_logo.svg by
/// scripts/branding.sh.
abstract final class AppImages {
  static const String _base = 'assets/images';
  static const String logo = '$_base/logo.png';
  static const String emptyInvoices = '$_base/empty_invoices.png';
  static const String onboardingWelcome = '$_base/onboarding/welcome.jpg';
  static const String onboardingOffline = '$_base/onboarding/offline.jpg';
  static const String onboardingTemplates = '$_base/onboarding/templates.jpg';
}
