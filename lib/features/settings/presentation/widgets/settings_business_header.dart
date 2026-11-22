import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/display/avatar_initials.dart';
import '../../../business_profile/business_profile.dart';

/// The business at the top of Settings: logo (or initials), name and an
/// Edit button that opens the business profile.
class SettingsBusinessHeader extends ConsumerWidget {
  const SettingsBusinessHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final profile = ref.watch(currentBusinessProfileProvider).value;
    final trimmed = profile?.name.trim() ?? '';
    final name = trimmed.isEmpty ? l10n.businessUntitled : trimmed;
    void edit() => context.pushNamed(RouteNames.businessProfile);
    return Row(
      spacing: AppSpacing.md,
      children: [
        _Logo(name: name, logoPath: profile?.logoPath),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.titleLarge?.copyWith(
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
          onPressed: edit,
          icon: const Icon(AppIcons.edit, size: AppSizes.iconSm),
          label: Text(l10n.edit),
          style: OutlinedButton.styleFrom(
            foregroundColor: colors.textPrimary,
            side: BorderSide(color: colors.border),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }
}

class _Logo extends ConsumerWidget {
  const _Logo({required this.name, this.logoPath});

  final String name;
  final String? logoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initials = AvatarInitials(name: name, size: AppSizes.avatarLg);
    final relative = logoPath;
    if (relative == null || relative.isEmpty) return initials;
    final absolute = ref.watch(profileImagePathProvider(relative)).value;
    if (absolute == null) return initials;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: context.appColors.border),
      ),
      child: ClipOval(
        child: Image.file(
          File(absolute),
          width: AppSizes.avatarLg,
          height: AppSizes.avatarLg,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => initials,
        ),
      ),
    );
  }
}
