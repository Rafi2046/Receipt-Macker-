import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/preferences/app_preferences.dart';
import '../../../../core/services/service_providers.dart';
import '../../domain/models/app_language.dart';
import '../../domain/models/app_theme_preference.dart';
import 'app_settings_state.dart';

part 'app_settings_view_model.g.dart';

/// App-wide settings, persisted in preferences. The full settings screen is M7.
@Riverpod(keepAlive: true)
class AppSettingsViewModel extends _$AppSettingsViewModel {
  AppPreferences get _prefs => ref.read(appPreferencesProvider);

  @override
  AppSettingsState build() {
    final prefs = ref.watch(appPreferencesProvider);
    return AppSettingsState(
      theme:
          AppThemePreference.values.asNameMap()[prefs.themeName] ??
          AppThemePreference.system,
      language: AppLanguage.values.firstWhere(
        (l) => l.code == prefs.languageCode,
        orElse: () => AppLanguage.en,
      ),
      defaultCurrency:
          prefs.defaultCurrency ?? AppConstants.defaultCurrencyCode,
    );
  }

  Future<void> setTheme(AppThemePreference theme) async {
    state = state.copyWith(theme: theme);
    await _prefs.setThemeName(theme.name);
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = state.copyWith(language: language);
    await _prefs.setLanguageCode(language.code);
  }

  Future<void> setDefaultCurrency(String code) async {
    state = state.copyWith(defaultCurrency: code);
    await _prefs.setDefaultCurrency(code);
  }
}
