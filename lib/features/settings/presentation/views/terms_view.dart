import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../widgets/legal_hero.dart';
import '../widgets/legal_page.dart';

/// Terms of use and of the Pro subscription, point by point.
class TermsView extends StatelessWidget {
  const TermsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    return LegalPage(
      title: l10n.termsTitle,
      hero: LegalHero(
        icon: AppIcons.termsHero,
        title: l10n.termsTitle,
        intro: l10n.termsIntro,
        note: l10n.legalUpdated(format.date(AppConstants.legalUpdatedOn)),
      ),
      sections: [
        (
          icon: AppIcons.appUse,
          title: l10n.termsUseTitle,
          body: l10n.termsUseBody,
        ),
        (
          icon: AppIcons.proPlan,
          title: l10n.termsProTitle,
          body: l10n.termsProBody,
        ),
        (
          icon: AppIcons.trial,
          title: l10n.termsTrialTitle,
          body: l10n.termsTrialBody,
        ),
        (
          icon: AppIcons.cancelPlan,
          title: l10n.termsCancelTitle,
          body: l10n.termsCancelBody,
        ),
        (
          icon: AppIcons.documents,
          title: l10n.termsContentTitle,
          body: l10n.termsContentBody,
        ),
        (
          icon: AppIcons.noWarranty,
          title: l10n.termsWarrantyTitle,
          body: l10n.termsWarrantyBody,
        ),
      ],
    );
  }
}
