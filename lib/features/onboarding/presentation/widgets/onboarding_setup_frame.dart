import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';

/// Brand hero field with a surface sheet docked to the bottom.
class OnboardingSetupFrame extends StatelessWidget {
  const OnboardingSetupFrame({
    required this.progress,
    required this.body,
    this.hero,
    this.bottomBar,
    super.key,
  });

  final Widget progress;

  /// Optional block on the brand field (logo, title) above the sheet.
  final Widget? hero;
  final Widget body;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ColoredBox(
      color: colors.primary,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.lg,
                AppSpacing.pagePadding,
                AppSpacing.md,
              ),
              child: progress,
            ),
            // Flexible (loose): only the space the hero needs, so the
            // sheet always fills down to the bottom edge.
            if (hero != null)
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pagePadding,
                    AppSpacing.sm,
                    AppSpacing.pagePadding,
                    AppSpacing.xl,
                  ),
                  child: hero,
                ),
              ),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.sheet,
                  boxShadow: [
                    BoxShadow(
                      color: colors.textPrimary.withValues(alpha: 0.16),
                      blurRadius: AppSpacing.xxl,
                      offset: const Offset(0, -AppSpacing.sm),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: body),
                    ?bottomBar,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
