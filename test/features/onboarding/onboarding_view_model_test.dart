import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/features/business_profile/business_profile.dart';
import 'package:receipt_maker/features/business_profile/domain/models/profile_field.dart';
import 'package:receipt_maker/features/onboarding/presentation/view_models/onboarding_state.dart';
import 'package:receipt_maker/features/onboarding/presentation/view_models/onboarding_view_model.dart';
import 'package:receipt_maker/features/onboarding/providers.dart';
import 'package:receipt_maker/features/settings/domain/models/app_language.dart';
import 'package:receipt_maker/features/settings/presentation/view_models/app_settings_view_model.dart';

import '../../helpers/test_env.dart';

void main() {
  late TestEnv env;
  late ProviderContainer container;

  OnboardingViewModel vm() =>
      container.read(onboardingViewModelProvider.notifier);
  OnboardingState state() => container.read(onboardingViewModelProvider);

  setUp(() async {
    env = TestEnv();
    container = env.container()
      ..listen(onboardingViewModelProvider, (_, _) {})
      ..listen(profileFormViewModelProvider, (_, _) {});
    await container.read(profileFormViewModelProvider.future);
  });
  tearDown(() async {
    container.dispose();
    await env.dispose();
  });

  test('details step needs a business name before continuing', () async {
    await vm().next();
    expect(state().step, OnboardingStep.details);

    await vm().next();
    expect(state().step, OnboardingStep.details);

    container
        .read(profileFormViewModelProvider.notifier)
        .updateField(ProfileField.name, 'Shop');
    await vm().next();
    expect(state().step, OnboardingStep.branding);
  });

  test('back walks to the previous step and stops at the first', () async {
    await vm().next();
    vm()
      ..back()
      ..back();
    expect(state().step, OnboardingStep.welcome);
  });

  test(
    'finish saves profile and currency, and marks onboarding done',
    () async {
      container
          .read(profileFormViewModelProvider.notifier)
          .updateField(ProfileField.name, 'রহমান ট্রেডার্স');
      vm().setCurrency('USD');
      await vm().next();
      await vm().next();
      await vm().next();

      expect(container.read(onboardingStatusProvider), isTrue);
      expect(env.prefs.onboardingComplete, isTrue);
      expect(env.prefs.defaultCurrency, 'USD');
      final saved = await container
          .read(businessProfileRepositoryProvider)
          .load();
      expect(saved.valueOrNull?.name, 'রহমান ট্রেডার্স');
    },
  );

  test('language choice persists', () async {
    await container
        .read(appSettingsViewModelProvider.notifier)
        .setLanguage(AppLanguage.bn);
    expect(env.prefs.languageCode, 'bn');
    expect(
      container.read(appSettingsViewModelProvider).language,
      AppLanguage.bn,
    );
  });
}
