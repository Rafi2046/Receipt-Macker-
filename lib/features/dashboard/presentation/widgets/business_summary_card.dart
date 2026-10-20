import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/display/avatar_initials.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../business_profile/business_profile.dart';

/// Logo (or initials), business name and contact line; taps open the profile.
class BusinessSummaryCard extends StatelessWidget {
  const BusinessSummaryCard({
    required this.profile,
    required this.actionLabel,
    required this.onTap,
    super.key,
  });

  final BusinessProfile profile;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final logo = profile.logoPath;
    // Bangla UI shows Bangla digits everywhere, including the stored phone.
    final digits = AppFormatters(Localizations.localeOf(context).languageCode);
    final contact = digits.localizeDigits(
      [profile.phone, profile.email].where((s) => s.isNotEmpty).join(' · '),
    );
    return AppCard(
      onTap: onTap,
      child: Row(
        spacing: AppSpacing.md,
        children: [
          SizedBox.square(
            dimension: AppSizes.avatarLg,
            child: logo == null
                ? AvatarInitials(name: profile.name, size: AppSizes.avatarLg)
                : ProfileImagePreview(
                    relativePath: logo,
                    semanticLabel: profile.name,
                    height: AppSizes.avatarLg,
                  ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.name, style: context.textStyles.titleMedium),
                if (contact.isNotEmpty)
                  Text(
                    contact,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                Text(
                  actionLabel,
                  style: context.textStyles.labelLarge?.copyWith(
                    color: context.appColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Icon(AppIcons.chevronRight, color: context.appColors.textSecondary),
        ],
      ),
    );
  }
}
