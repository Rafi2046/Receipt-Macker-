import 'package:receipt_maker/core/services/preferences/app_preferences.dart';

/// In-memory [AppPreferences] for tests.
class FakeAppPreferences implements AppPreferences {
  FakeAppPreferences({
    this.onboardingComplete = false,
    this.languageCode = 'en',
    this.themeName,
    this.defaultCurrency,
    this.pdfTemplate,
    this.isPro = false,
    this.firstLaunchMillis,
    this.completedExports = 0,
    this.lastInterstitialMillis,
  });

  @override
  bool onboardingComplete;

  @override
  String? languageCode;

  @override
  String? themeName;

  @override
  String? defaultCurrency;

  @override
  Future<void> setOnboardingComplete({required bool value}) async =>
      onboardingComplete = value;

  @override
  Future<void> setLanguageCode(String code) async => languageCode = code;

  @override
  Future<void> setThemeName(String name) async => themeName = name;

  @override
  Future<void> setDefaultCurrency(String code) async => defaultCurrency = code;

  @override
  String? pdfTemplate;

  @override
  Future<void> setPdfTemplate(String id) async => pdfTemplate = id;

  @override
  bool isPro;

  @override
  int? firstLaunchMillis;

  @override
  int completedExports;

  @override
  int? lastInterstitialMillis;

  @override
  Future<void> setPro({required bool value}) async => isPro = value;

  @override
  Future<void> setFirstLaunchMillis(int millis) async =>
      firstLaunchMillis = millis;

  @override
  Future<void> setCompletedExports(int count) async => completedExports = count;

  @override
  Future<void> setLastInterstitialMillis(int millis) async =>
      lastInterstitialMillis = millis;
}
