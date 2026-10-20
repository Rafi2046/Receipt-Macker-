import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../view_models/onboarding_state.dart';

/// Back / Continue, or Skip / Finish on the last step.
class OnboardingNavBar extends StatelessWidget {
  const OnboardingNavBar({
    required this.state,
    required this.hasImages,
    required this.onBack,
    required this.onNext,
    super.key,
  });

  final OnboardingState state;

  /// On the last step the secondary action reads "Skip for now" until the
  /// user adds a logo or signature.
  final bool hasImages;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final busy = state.isFinishing;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Row(
          spacing: AppSpacing.sm,
          children: [
            if (!state.isFirst)
              AppButton(
                label: l10n.back,
                variant: AppButtonVariant.text,
                onPressed: busy ? null : onBack,
              ),
            // The forward action takes the rest of the row and wraps its
            // label at large font sizes instead of overflowing.
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: state.isLast && !hasImages
                        ? AppButton(
                            label: l10n.skipForNow,
                            variant: AppButtonVariant.text,
                            onPressed: busy ? null : onNext,
                          )
                        : AppButton(
                            label: state.isLast ? l10n.finishSetup : l10n.next,
                            icon: state.isLast
                                ? AppIcons.check
                                : AppIcons.forward,
                            isLoading: busy,
                            onPressed: onNext,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
