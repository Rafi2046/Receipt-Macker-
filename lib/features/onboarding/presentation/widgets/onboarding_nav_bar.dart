import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../view_models/onboarding_state.dart';

/// Full-width Continue inside the white sheet.
class OnboardingNavBar extends StatelessWidget {
  const OnboardingNavBar({
    required this.state,
    required this.hasImages,
    required this.onBack,
    required this.onNext,
    super.key,
  });

  final OnboardingState state;

  /// On the last step the forward label is "Skip for now" until a logo or
  /// signature is added.
  final bool hasImages;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final busy = state.isFinishing;
    final skipLast = state.isLast && !hasImages;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!state.isFirst)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: busy ? null : onBack,
                  child: Text(
                    l10n.back,
                    style: context.textStyles.titleSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            AppButton(
              label: state.isLast
                  ? (skipLast ? l10n.skipForNow : l10n.finishSetup)
                  : l10n.next,
              icon: state.isLast && !skipLast
                  ? AppIcons.check
                  : AppIcons.forward,
              expand: true,
              isLoading: busy,
              variant: skipLast
                  ? AppButtonVariant.secondary
                  : AppButtonVariant.primary,
              onPressed: onNext,
            ),
          ],
        ),
      ),
    );
  }
}
