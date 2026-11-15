import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions/failure_message_extension.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../business_profile/business_profile.dart';
import '../view_models/onboarding_state.dart';
import '../view_models/onboarding_view_model.dart';
import '../widgets/branding_step.dart';
import '../widgets/details_step.dart';
import '../widgets/intro_tour_view.dart';
import '../widgets/onboarding_nav_bar.dart';
import '../widgets/onboarding_setup_frame.dart';
import '../widgets/step_intro.dart';
import '../widgets/step_progress.dart';
import '../widgets/welcome_step.dart';

/// First-run flow: marketing tour, then language / business setup.
/// Android back goes to the previous setup step.
class OnboardingView extends ConsumerWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(profileFormViewModelProvider.select((s) => s.value?.failure), (
      _,
      failure,
    ) {
      if (failure == null) return;
      AppSnackbar.show(
        context,
        context.l10n.messageFor(failure),
        tone: AppSnackbarTone.error,
      );
      ref.read(profileFormViewModelProvider.notifier).clearFailure();
    });
    final state = ref.watch(onboardingViewModelProvider);
    final vm = ref.read(onboardingViewModelProvider.notifier);
    if (state.showingTour) {
      return IntroTourView(onFinished: vm.finishTour);
    }
    final formAsync = ref.watch(profileFormViewModelProvider);
    final form = formAsync.value;
    final l10n = context.l10n;
    return PopScope(
      canPop: state.isFirst,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) vm.back();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: OnboardingSetupFrame(
          progress: StepProgress(
            current: state.step.index + 1,
            total: OnboardingStep.values.length,
          ),
          hero: switch (state.step) {
            OnboardingStep.welcome => const WelcomeHero(),
            OnboardingStep.details => _CoralTitle(
              title: l10n.onboardingDetailsTitle,
              body: l10n.onboardingDetailsBody,
            ),
            OnboardingStep.branding => _CoralTitle(
              title: l10n.onboardingBrandingTitle,
              body: l10n.onboardingBrandingBody,
            ),
          },
          body: formAsync.when(
            data: (form) => _StepContent(
              state: state,
              form: form,
              onCurrencyChanged: vm.setCurrency,
            ),
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView.fromError(
              e,
              onRetry: () => ref.invalidate(profileFormViewModelProvider),
            ),
          ),
          bottomBar: form == null
              ? null
              : OnboardingNavBar(
                  state: state,
                  hasImages:
                      form.draft.logoPath != null ||
                      form.draft.signaturePath != null,
                  onBack: vm.back,
                  onNext: vm.next,
                ),
        ),
      ),
    );
  }
}

class _CoralTitle extends StatelessWidget {
  const _CoralTitle({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return StepIntro(title: title, body: body, onCoral: true);
  }
}

class _StepContent extends StatelessWidget {
  const _StepContent({
    required this.state,
    required this.form,
    required this.onCurrencyChanged,
  });

  final OnboardingState state;
  final ProfileFormState form;
  final ValueChanged<String> onCurrencyChanged;

  @override
  Widget build(BuildContext context) => switch (state.step) {
    OnboardingStep.welcome => const WelcomeStep(),
    OnboardingStep.details => DetailsStep(
      form: form,
      currencyCode: state.currencyCode,
      onCurrencyChanged: onCurrencyChanged,
    ),
    OnboardingStep.branding => BrandingStep(form: form),
  };
}
