import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/display/avatar_initials.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../domain/models/client.dart';

/// One client as a card: initials, name, then phone and email on their
/// own lines when present. [showChevron] marks a card that opens the
/// client (off in the picker, where a tap picks it).
class ClientListTile extends StatelessWidget {
  const ClientListTile({
    required this.client,
    required this.onTap,
    this.showChevron = true,
    super.key,
  });

  final Client client;
  final VoidCallback onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    // Bangla UI shows Bangla digits everywhere, including stored phones.
    final digits = AppFormatters(Localizations.localeOf(context).languageCode);
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          AvatarInitials(name: client.name),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Text(
                  client.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (client.phone.isNotEmpty)
                  _ContactLine(
                    icon: AppIcons.phone,
                    text: digits.localizeDigits(client.phone),
                  ),
                if (client.email.isNotEmpty)
                  _ContactLine(icon: AppIcons.email, text: client.email),
              ],
            ),
          ),
          if (showChevron)
            Icon(
              AppIcons.chevronRight,
              size: AppSizes.iconMd,
              color: context.appColors.textSecondary,
            ),
        ],
      ),
    );
  }
}

/// A small icon and one line of muted text.
class _ContactLine extends StatelessWidget {
  const _ContactLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final muted = context.appColors.textSecondary;
    return Row(
      spacing: AppSpacing.sm,
      children: [
        Icon(icon, size: AppSizes.iconSm, color: muted),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.bodySmall?.copyWith(color: muted),
          ),
        ),
      ],
    );
  }
}
