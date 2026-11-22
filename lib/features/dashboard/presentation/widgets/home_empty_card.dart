import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/empty_illustration.dart';
import '../../../../core/widgets/layout/app_card.dart';

/// Empty invoices prompt for Home. Content stays centred when the card is
/// stretched to fill the remaining height.
class HomeEmptyCard extends StatelessWidget {
  const HomeEmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    return AppCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const EmptyIllustration(icon: AppIcons.invoice),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.invoicesEmptyTitle,
            textAlign: TextAlign.center,
            style: context.textStyles.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.invoicesEmptyBody,
            textAlign: TextAlign.center,
            style: context.textStyles.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: l10n.invoicesEmptyAction,
            expand: true,
            onPressed: () => context.pushNamed(RouteNames.invoiceNew),
          ),
        ],
      ),
    );
  }
}
