import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/display/avatar_initials.dart';
import '../../../business_profile/business_profile.dart';

/// Business identity card on Settings — tap opens the profile editor.
/// Navigation back lives in the AppBar, not here.
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

    return Material(
      color: colors.surface,
      borderRadius: AppRadius.card,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: edit,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
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
              Icon(
                AppIcons.chevronRight,
                size: AppSizes.iconSm,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends ConsumerWidget {
  const _Logo({required this.name, this.logoPath});

  final String name;
  final String? logoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initials = AvatarInitials(name: name);
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
          width: AppSizes.avatarMd,
          height: AppSizes.avatarMd,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => initials,
        ),
      ),
    );
  }
}
