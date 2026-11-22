import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Full coral page with a white sheet docked at the bottom — tour language.
class OnboardingSetupFrame extends StatelessWidget {
  const OnboardingSetupFrame({
    required this.progress,
    required this.body,
    this.hero,
    this.bottomBar,
    super.key,
  });

  final Widget progress;

  /// Optional block on the coral field (logo, title) above the sheet.
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
            // At large font sizes the hero may take at most half the space
            // and scrolls inside it, so the sheet below keeps room.
            if (hero != null)
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pagePadding,
                    0,
                    AppSpacing.pagePadding,
                    AppSpacing.lg,
                  ),
                  child: hero,
                ),
              ),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.xxxl),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.textPrimary.withValues(alpha: 0.18),
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
