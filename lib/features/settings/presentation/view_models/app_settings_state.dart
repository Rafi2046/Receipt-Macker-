import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/app_language.dart';
import '../../domain/models/app_palette_id.dart';
import '../../domain/models/app_theme_preference.dart';

part 'app_settings_state.freezed.dart';

@freezed
abstract class AppSettingsState with _$AppSettingsState {
  const factory AppSettingsState({
    @Default(AppThemePreference.system) AppThemePreference theme,
    @Default(AppLanguage.en) AppLanguage language,
    @Default(AppPaletteId.teal) AppPaletteId palette,
  }) = _AppSettingsState;
}
