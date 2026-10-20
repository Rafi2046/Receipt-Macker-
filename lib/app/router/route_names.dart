/// Route names and paths. Navigate by name, never by raw strings in widgets.
abstract final class RouteNames {
  static const String home = 'home';
  static const String homePath = '/';
  static const String onboarding = 'onboarding';
  static const String onboardingPath = '/onboarding';
  static const String businessProfile = 'businessProfile';
  static const String businessProfilePath = '/business-profile';

  // Debug builds only.
  static const String themePreview = 'themePreview';
  static const String themePreviewPath = '/debug/theme';
  static const String widgetGallery = 'widgetGallery';
  static const String widgetGalleryPath = '/debug/widgets';
}
