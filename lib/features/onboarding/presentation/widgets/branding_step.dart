import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../business_profile/business_profile.dart';

/// Step 3: optional logo and signature. Title is in the coral hero.
class BrandingStep extends StatelessWidget {
  const BrandingStep({required this.form, super.key});

  final ProfileFormState form;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      children: [ProfileImagesSection(form: form)],
    );
  }
}
