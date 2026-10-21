import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';

/// Shown after a purchase or restore. Lists what Pro unlocked.
class ProWelcomeView extends StatelessWidget {
  const ProWelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppScaffold(
      title: l10n.proWelcomeTitle,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          Text(l10n.proWelcomeBody, style: context.textStyles.bodyLarge),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.proManage,
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          AppButton(
            label: l10n.proWelcomeDone,
            expand: true,
            onPressed: () => context.goNamed(RouteNames.home),
          ),
        ],
      ),
    );
  }
}
