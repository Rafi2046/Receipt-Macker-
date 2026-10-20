import 'package:receipt_maker/core/services/preferences/app_preferences.dart';

/// In-memory [AppPreferences] for tests.
class FakeAppPreferences implements AppPreferences {
  FakeAppPreferences({
    this.onboardingComplete = false,
    this.languageCode = 'en',
    this.themeName,
    this.defaultCurrency,
    this.pdfTemplate,
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
}
