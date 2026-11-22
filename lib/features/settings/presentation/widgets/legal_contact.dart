import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/url_launch_service.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';

/// "Questions?" as plain text with the support email as a tappable link.
class LegalContact extends StatelessWidget {
  const LegalContact({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final subject = Uri.encodeComponent(l10n.supportEmailSubject);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Text(
          l10n.legalContactTitle,
          style: context.textStyles.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          l10n.legalContactBody,
          style: context.textStyles.bodyMedium?.copyWith(
            color: colors.textPrimary.withValues(alpha: 0.8),
            height: 1.6,
          ),
        ),
        Semantics(
          link: true,
          child: InkWell(
            onTap: () => UrlLaunchService.openUrl(
              'mailto:${AppConstants.supportEmail}?subject=$subject',
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                AppConstants.supportEmail,
                style: context.textStyles.bodyLarge?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: colors.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
