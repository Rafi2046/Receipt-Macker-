import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/url_launch_service.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/layout/app_card.dart';

/// The support email with "Send an email" and "Copy email" actions.
class SupportContactCard extends StatelessWidget {
  const SupportContactCard({
    required this.title,
    required this.body,
    super.key,
  });

  final String title;
  final String body;

  Future<void> _email(BuildContext context) {
    final subject = Uri.encodeComponent(context.l10n.supportEmailSubject);
    return UrlLaunchService.openUrl(
      'mailto:${AppConstants.supportEmail}?subject=$subject',
    );
  }

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(
      const ClipboardData(text: AppConstants.supportEmail),
    );
    if (!context.mounted) return;
    AppSnackbar.show(
      context,
      context.l10n.supportEmailCopied,
      tone: AppSnackbarTone.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          Text(
            title,
            style: context.textStyles.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            body,
            style: context.textStyles.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: AppRadius.card,
            ),
            child: Row(
              spacing: AppSpacing.sm,
              children: [
                Icon(
                  AppIcons.mail,
                  size: AppSizes.iconRow,
                  color: colors.primary,
                ),
                Expanded(
                  child: SelectableText(
                    AppConstants.supportEmail,
                    style: context.textStyles.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppButton(
            label: l10n.supportEmailAction,
            icon: AppIcons.mail,
            expand: true,
            onPressed: () => _email(context),
          ),
          AppButton(
            label: l10n.supportCopyEmail,
            icon: AppIcons.copy,
            variant: AppButtonVariant.secondary,
            expand: true,
            onPressed: () => _copy(context),
          ),
        ],
      ),
    );
  }
}
