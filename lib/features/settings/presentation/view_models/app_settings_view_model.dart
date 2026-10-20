import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/app_language.dart';
import '../../domain/models/app_theme_preference.dart';
import 'app_settings_state.dart';

part 'app_settings_view_model.g.dart';

/// App-wide appearance settings. In-memory for M0; persisted in M7.
@Riverpod(keepAlive: true)
class AppSettingsViewModel extends _$AppSettingsViewModel {
  @override
  AppSettingsState build() => const AppSettingsState();

  void setTheme(AppThemePreference theme) =>
      state = state.copyWith(theme: theme);

  void setLanguage(AppLanguage language) =>
      state = state.copyWith(language: language);
}
