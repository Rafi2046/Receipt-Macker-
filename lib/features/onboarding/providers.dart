import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/services/service_providers.dart';

part 'providers.g.dart';

/// Whether first-run setup is done. The router sends users to onboarding
/// until this is true.
@Riverpod(keepAlive: true)
class OnboardingStatus extends _$OnboardingStatus {
  @override
  bool build() => ref.watch(appPreferencesProvider).onboardingComplete;

  Future<void> markComplete() async {
    await ref.read(appPreferencesProvider).setOnboardingComplete(value: true);
    state = true;
  }
}
