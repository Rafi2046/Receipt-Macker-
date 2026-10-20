import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../business_profile/business_profile.dart';
import '../../../settings/presentation/view_models/app_settings_view_model.dart';
import '../../providers.dart';
import 'onboarding_state.dart';

part 'onboarding_view_model.g.dart';

/// First-run flow: welcome + language, business details, logo + signature.
/// Profile fields live in [ProfileFormViewModel]; this drives the steps.
@riverpod
class OnboardingViewModel extends _$OnboardingViewModel {
  @override
  OnboardingState build() => OnboardingState(
    currencyCode: ref.read(appSettingsViewModelProvider).defaultCurrency,
  );

  ProfileFormViewModel get _form =>
      ref.read(profileFormViewModelProvider.notifier);

  void setCurrency(String code) => state = state.copyWith(currencyCode: code);

  /// Moves forward. The details step only continues once the name is valid.
  Future<void> next() async {
    switch (state.step) {
      case OnboardingStep.welcome:
        state = state.copyWith(step: OnboardingStep.details);
      case OnboardingStep.details:
        if (_form.validate()) {
          state = state.copyWith(step: OnboardingStep.branding);
        }
      case OnboardingStep.branding:
        await finish();
    }
  }

  void back() {
    if (state.isFirst) return;
    state = state.copyWith(step: OnboardingStep.values[state.step.index - 1]);
  }

  /// Saves the profile and default currency, then marks onboarding done,
  /// which makes the router leave this flow.
  Future<void> finish() async {
    if (state.isFinishing) return;
    state = state.copyWith(isFinishing: true);
    final saved = await _form.save();
    if (!saved) {
      state = state.copyWith(isFinishing: false);
      return;
    }
    await ref
        .read(appSettingsViewModelProvider.notifier)
        .setDefaultCurrency(state.currencyCode);
    await ref.read(onboardingStatusProvider.notifier).markComplete();
  }
}
