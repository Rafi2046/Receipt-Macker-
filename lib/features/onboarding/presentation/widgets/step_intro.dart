import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Title and one-line explanation. [onCoral] uses white type for the hero.
class StepIntro extends StatelessWidget {
  const StepIntro({
    required this.title,
    required this.body,
    this.onCoral = false,
    super.key,
  });

  final String title;
  final String body;
  final bool onCoral;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final titleColor = onCoral ? colors.onPrimary : colors.textPrimary;
    final bodyColor = onCoral
        ? colors.onPrimary.withValues(alpha: 0.88)
        : colors.textSecondary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: context.textStyles.headlineSmall?.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          body,
          style: context.textStyles.bodyLarge?.copyWith(color: bodyColor),
        ),
      ],
    );
  }
}
