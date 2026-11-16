import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/display/avatar_initials.dart';
import '../../../business_profile/providers.dart';

/// Business logo (or initials) + name + edit shortcut at the top of the menu.
class AppMenuHeader extends ConsumerWidget {
  const AppMenuHeader({
    required this.name,
    required this.onEdit,
    this.logoPath,
    super.key,
  });

  final String name;
  final String? logoPath;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    return Row(
      children: [
        _MenuAvatar(name: name, logoPath: logoPath),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                l10n.homeEditProfile,
                style: context.textStyles.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: onEdit,
          icon: const Icon(AppIcons.edit, size: AppSizes.iconSm),
          label: Text(l10n.edit),
          style: OutlinedButton.styleFrom(
            foregroundColor: colors.primary,
            side: BorderSide(color: colors.primary),
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          ),
        ),
      ],
    );
  }
}

class _MenuAvatar extends ConsumerWidget {
  const _MenuAvatar({required this.name, this.logoPath});

  final String name;
  final String? logoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relative = logoPath;
    if (relative == null || relative.isEmpty) {
      return AvatarInitials(name: name, size: AppSizes.avatarLg);
    }
    final absolute = ref.watch(profileImagePathProvider(relative)).value;
    if (absolute == null) {
      return AvatarInitials(name: name, size: AppSizes.avatarLg);
    }
    return ClipOval(
      child: Image.file(
        File(absolute),
        width: AppSizes.avatarLg,
        height: AppSizes.avatarLg,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            AvatarInitials(name: name, size: AppSizes.avatarLg),
      ),
    );
  }
}
