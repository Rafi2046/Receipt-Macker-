import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

enum OnboardingStep { welcome, details, branding }

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    /// Marketing slides before language / business setup.
    @Default(true) bool showingTour,
    @Default(OnboardingStep.welcome) OnboardingStep step,
    required String currencyCode,
    @Default(false) bool isFinishing,
  }) = _OnboardingState;

  const OnboardingState._();

  /// First setup step (after the tour). Tour back is handled in the tour UI.
  bool get isFirst => !showingTour && step == OnboardingStep.welcome;

  bool get isLast => !showingTour && step == OnboardingStep.branding;
}
