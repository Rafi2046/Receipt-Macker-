import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/buttons/app_icon_button.dart';

class GalleryButtonsSection extends StatelessWidget {
  const GalleryButtonsSection({
    required this.isSaving,
    required this.onToggleSaving,
    super.key,
  });

  final bool isSaving;
  final VoidCallback onToggleSaving;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        AppButton(
          label: l10n.galleryPrimary,
          icon: AppIcons.invoice,
          isLoading: isSaving,
          onPressed: () {},
        ),
        AppButton(
          label: l10n.gallerySecondary,
          variant: AppButtonVariant.secondary,
          onPressed: () {},
        ),
        AppButton(
          label: l10n.galleryDanger,
          variant: AppButtonVariant.danger,
          icon: AppIcons.delete,
          onPressed: () {},
        ),
        AppButton(label: l10n.galleryDisabled, onPressed: null),
        Wrap(
          spacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppButton(
              label: l10n.galleryToggleLoading,
              variant: AppButtonVariant.text,
              onPressed: onToggleSaving,
            ),
            AppIconButton(
              icon: AppIcons.share,
              semanticLabel: l10n.galleryShare,
              onPressed: () {},
            ),
            AppIconButton(
              icon: AppIcons.print,
              semanticLabel: l10n.galleryPrint,
              filled: true,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
