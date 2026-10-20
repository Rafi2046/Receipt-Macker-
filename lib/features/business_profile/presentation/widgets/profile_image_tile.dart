import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/layout/app_card.dart';
import 'profile_image_preview.dart';

/// Title, hint, preview and add / change / remove actions for one image.
class ProfileImageTile extends StatelessWidget {
  const ProfileImageTile({
    required this.title,
    required this.hint,
    required this.addLabel,
    required this.addIcon,
    required this.relativePath,
    required this.onAdd,
    required this.onRemove,
    this.isBusy = false,
    super.key,
  });

  final String title;
  final String hint;
  final String addLabel;
  final IconData addIcon;
  final String? relativePath;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final path = relativePath;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          Text(title, style: context.textStyles.titleSmall),
          Text(
            hint,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
          if (path != null)
            ProfileImagePreview(relativePath: path, semanticLabel: title),
          if (path == null)
            AppButton(
              label: addLabel,
              icon: addIcon,
              variant: AppButtonVariant.secondary,
              isLoading: isBusy,
              onPressed: onAdd,
            )
          else
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                AppButton(
                  label: l10n.change,
                  icon: AppIcons.edit,
                  variant: AppButtonVariant.text,
                  isLoading: isBusy,
                  onPressed: onAdd,
                ),
                AppButton(
                  label: l10n.remove,
                  icon: AppIcons.delete,
                  variant: AppButtonVariant.text,
                  onPressed: onRemove,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
