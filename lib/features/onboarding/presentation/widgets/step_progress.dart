import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';

/// "Step 2 of 3" on the coral field — light label, white track.
class StepProgress extends StatelessWidget {
  const StepProgress({required this.current, required this.total, super.key});

  /// 1-based.
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final label = context.l10n.onboardingStep(current, total);
    final colors = context.appColors;
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          Text(
            label,
            style: context.textStyles.labelLarge?.copyWith(
              color: colors.onPrimary.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
          ClipRRect(
            borderRadius: AppRadius.chip,
            child: LinearProgressIndicator(
              value: current / total,
              minHeight: AppSpacing.sm,
              backgroundColor: colors.onPrimary.withValues(alpha: 0.28),
              color: colors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
