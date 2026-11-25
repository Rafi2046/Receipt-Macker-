import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_opacity.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';

/// Brand gradient field with a surface sheet docked to the bottom.
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
    final deep = Color.alphaBlend(
      colors.textPrimary.withValues(alpha: 0.22),
      colors.primary,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, deep],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _HeroGlow(),
          SafeArea(
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
                // Loose Flexible: hero only takes what it needs so the sheet
                // always fills to the bottom.
                if (hero != null)
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.pagePadding,
                        AppSpacing.md,
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
                          color: colors.textPrimary.withValues(
                            alpha: AppOpacity.shadow,
                          ),
                          blurRadius: AppSpacing.xxxl,
                          offset: const Offset(0, -AppSpacing.md),
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
        ],
      ),
    );
  }
}

/// Soft light orbs behind the hero copy — atmosphere only.
class _HeroGlow extends StatelessWidget {
  const _HeroGlow();

  @override
  Widget build(BuildContext context) {
    final glow = context.appColors.onPrimary.withValues(alpha: 0.1);
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -AppSpacing.xxxl * 2,
            right: -AppSpacing.xxxl * 2,
            child: _Orb(size: AppSpacing.xxxl * 7, color: glow),
          ),
          Positioned(
            top: AppSpacing.xxxl * 3,
            left: -AppSpacing.xxxl * 2,
            child: _Orb(size: AppSpacing.xxxl * 5, color: glow),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
