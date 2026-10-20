import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

enum OnboardingStep { welcome, details, branding }

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(OnboardingStep.welcome) OnboardingStep step,
    required String currencyCode,
    @Default(false) bool isFinishing,
  }) = _OnboardingState;

  const OnboardingState._();

  bool get isFirst => step == OnboardingStep.welcome;

  bool get isLast => step == OnboardingStep.branding;
}
