import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widgets/launcher_icon_preview.dart';

/// Debug screen: a full-screen mock of the Android 12+ splash for one
/// concept: the icon in a circle on the app background. Tap to close.
class LogoSplashPreviewView extends StatelessWidget {
  const LogoSplashPreviewView({
    required this.concept,
    required this.dark,
    super.key,
  });

  final int concept;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final colors = dark ? AppColors.dark() : AppColors.light();
    final asset = AppImages
        .logoConcepts[concept.clamp(0, AppImages.logoConcepts.length - 1)];
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: ColoredBox(
          color: colors.background,
          child: Center(
            child: LauncherIconPreview(
              asset: asset,
              size: AppSizes.splashIcon,
              mask: LauncherMask.circle,
            ),
          ),
        ),
      ),
    );
  }
}
