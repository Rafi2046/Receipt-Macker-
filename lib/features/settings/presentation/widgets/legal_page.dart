import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import 'legal_hero.dart';
import 'legal_section_card.dart';
import 'support_contact_card.dart';

/// A legal page: hero, one card per point, then how to reach us.
class LegalPage extends StatelessWidget {
  const LegalPage({
    required this.title,
    required this.hero,
    required this.sections,
    super.key,
  });

  final String title;
  final LegalHero hero;
  final List<LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppScaffold(
      title: title,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.sm,
          AppSpacing.pagePadding,
          AppSizes.fabClearance,
        ),
        children: [
          hero,
          const SizedBox(height: AppSpacing.lg),
          for (final section in sections) ...[
            LegalSectionCard(section: section),
            const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.sm),
          SupportContactCard(
            title: l10n.legalContactTitle,
            body: l10n.legalContactBody,
          ),
        ],
      ),
    );
  }
}
