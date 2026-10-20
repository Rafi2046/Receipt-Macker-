import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Title and one-line explanation at the top of an onboarding step.
class StepIntro extends StatelessWidget {
  const StepIntro({required this.title, required this.body, super.key});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: context.textStyles.titleLarge),
        ),
        Text(
          body,
          style: context.textStyles.bodyMedium?.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
