import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_bar_variant.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../widgets/faq_tile.dart';
import '../widgets/legal_hero.dart';
import '../widgets/settings_group.dart';
import '../widgets/support_contact_card.dart';

/// Help: email us (with what to include) and answers to common questions.
class SupportView extends StatelessWidget {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final faqs = [
      (l10n.supportFaq1Q, l10n.supportFaq1A),
      (l10n.supportFaq2Q, l10n.supportFaq2A),
      (l10n.supportFaq3Q, l10n.supportFaq3A),
      (l10n.supportFaq4Q, l10n.supportFaq4A),
      (l10n.supportFaq5Q, l10n.supportFaq5A),
    ];
    return AppScaffold(
      title: l10n.menuSupport,
      variant: AppBarVariant.pushed,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.sm,
          AppSpacing.pagePadding,
          AppSizes.fabClearance,
        ),
        children: [
          LegalHero(
            icon: AppIcons.supportHero,
            title: l10n.supportTitle,
            intro: l10n.supportIntro,
          ),
          const SizedBox(height: AppSpacing.lg),
          SupportContactCard(
            title: l10n.menuSupport,
            body: l10n.menuSupportHint,
          ),
          const SizedBox(height: AppSpacing.md),
          const _Tips(),
          const SizedBox(height: AppSpacing.sectionGap),
          SettingsGroup(
            title: l10n.supportFaqTitle,
            dividerIndent: AppSpacing.lg,
            children: [
              for (final (q, a) in faqs) FaqTile(question: q, answer: a),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tips extends StatelessWidget {
  const _Tips();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final tips = [
      l10n.supportTip1,
      l10n.supportTip2,
      l10n.supportTip3,
      l10n.supportTip4,
    ];
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          Row(
            spacing: AppSpacing.sm,
            children: [
              Icon(AppIcons.tip, size: AppSizes.iconRow, color: colors.warning),
              Text(
                l10n.supportTipsTitle,
                style: context.textStyles.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          for (final tip in tips)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                Icon(
                  AppIcons.tipCheck,
                  size: AppSizes.iconSm,
                  color: colors.success,
                ),
                Expanded(
                  child: Text(
                    tip,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
