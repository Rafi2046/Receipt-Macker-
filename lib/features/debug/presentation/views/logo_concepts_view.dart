import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../widgets/launcher_icon_preview.dart';
import '../widgets/preview_section.dart';
import '../widgets/wallpaper_panel.dart';

/// Debug screen: the three logo concepts as launcher icons on light, dark
/// and colorful wallpapers, at small sizes, and links to splash previews.
class LogoConceptsView extends StatelessWidget {
  const LogoConceptsView({super.key});

  static const List<double> _smallSizes = [48, 32, 24, 16];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final light = AppColors.light();
    final dark = AppColors.dark();
    return AppScaffold(
      title: l10n.logoConceptsTitle,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          PreviewSection(
            title: l10n.logoLightWallpaper,
            child: WallpaperPanel(
              gradient: [light.surface, light.border],
              labelColor: light.textPrimary,
            ),
          ),
          PreviewSection(
            title: l10n.logoDarkWallpaper,
            child: WallpaperPanel(
              gradient: [dark.background, dark.surfaceAlt],
              labelColor: dark.textPrimary,
            ),
          ),
          PreviewSection(
            title: l10n.logoColorWallpaper,
            child: WallpaperPanel(
              gradient: [light.info, light.secondary],
              labelColor: light.onPrimary,
            ),
          ),
          PreviewSection(
            title: l10n.logoSmallSizes,
            child: const _SmallSizes(sizes: _smallSizes),
          ),
          PreviewSection(title: l10n.logoSplash, child: const _SplashLinks()),
        ],
      ),
    );
  }
}

class _SmallSizes extends StatelessWidget {
  const _SmallSizes({required this.sizes});

  final List<double> sizes;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.md,
      children: [
        for (final asset in AppImages.logoConcepts)
          Row(
            spacing: AppSpacing.lg,
            children: [
              for (final s in sizes)
                LauncherIconPreview(
                  asset: asset,
                  size: s,
                  mask: LauncherMask.circle,
                ),
            ],
          ),
      ],
    );
  }
}

class _SplashLinks extends StatelessWidget {
  const _SplashLinks();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (var i = 0; i < AppImages.logoConcepts.length; i++)
          for (final dark in [false, true])
            AppButton(
              label: (dark ? l10n.logoSplashDark : l10n.logoSplashLight)(
                l10n.logoConceptName(
                  String.fromCharCode('A'.codeUnitAt(0) + i),
                ),
              ),
              variant: AppButtonVariant.secondary,
              onPressed: () => context.pushNamed(
                RouteNames.logoSplash,
                queryParameters: {
                  RouteNames.conceptParam: '$i',
                  RouteNames.darkParam: '$dark',
                },
              ),
            ),
      ],
    );
  }
}
