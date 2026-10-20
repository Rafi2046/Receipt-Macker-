import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';

/// "Step 2 of 3" with a progress bar.
class StepProgress extends StatelessWidget {
  const StepProgress({required this.current, required this.total, super.key});

  /// 1-based.
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final label = context.l10n.onboardingStep(current, total);
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xs,
        children: [
          Text(
            label,
            style: context.textStyles.labelMedium?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
          ClipRRect(
            borderRadius: AppRadius.chip,
            child: LinearProgressIndicator(
              value: current / total,
              backgroundColor: context.appColors.border,
            ),
          ),
        ],
      ),
    );
  }
}
