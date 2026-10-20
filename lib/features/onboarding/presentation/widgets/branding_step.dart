import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../business_profile/business_profile.dart';
import 'step_intro.dart';

/// Step 3: optional logo and signature.
class BrandingStep extends StatelessWidget {
  const BrandingStep({required this.form, super.key});

  final ProfileFormState form;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      children: [
        StepIntro(
          title: l10n.onboardingBrandingTitle,
          body: l10n.onboardingBrandingBody,
        ),
        const SizedBox(height: AppSpacing.xl),
        ProfileImagesSection(form: form),
      ],
    );
  }
}
