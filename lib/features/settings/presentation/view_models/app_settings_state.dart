import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/models/app_language.dart';
import '../../domain/models/app_theme_preference.dart';

part 'app_settings_state.freezed.dart';

@freezed
abstract class AppSettingsState with _$AppSettingsState {
  const factory AppSettingsState({
    @Default(AppThemePreference.system) AppThemePreference theme,
    @Default(AppLanguage.en) AppLanguage language,
    @Default(AppConstants.defaultCurrencyCode) String defaultCurrency,
  }) = _AppSettingsState;
}
