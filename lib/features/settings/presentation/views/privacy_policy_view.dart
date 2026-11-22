import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../widgets/legal_hero.dart';
import '../widgets/legal_page.dart';

/// How QuickBill handles data, point by point.
class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    return LegalPage(
      title: l10n.privacyTitle,
      hero: LegalHero(
        icon: AppIcons.privacyHero,
        title: l10n.privacyTitle,
        intro: l10n.privacyIntro,
        note: l10n.legalUpdated(format.date(AppConstants.legalUpdatedOn)),
      ),
      sections: [
        (
          icon: AppIcons.onDevice,
          title: l10n.privacyLocalTitle,
          body: l10n.privacyLocalBody,
        ),
        (
          icon: AppIcons.backupFile,
          title: l10n.privacyBackupTitle,
          body: l10n.privacyBackupBody,
        ),
        (
          icon: AppIcons.ads,
          title: l10n.privacyAdsTitle,
          body: l10n.privacyAdsBody,
        ),
        (
          icon: AppIcons.purchase,
          title: l10n.privacyPurchaseTitle,
          body: l10n.privacyPurchaseBody,
        ),
        (
          icon: AppIcons.analytics,
          title: l10n.privacyAnalyticsTitle,
          body: l10n.privacyAnalyticsBody,
        ),
        (
          icon: AppIcons.photos,
          title: l10n.privacyPermissionsTitle,
          body: l10n.privacyPermissionsBody,
        ),
        (
          icon: AppIcons.deleteData,
          title: l10n.privacyDeleteTitle,
          body: l10n.privacyDeleteBody,
        ),
        (
          icon: AppIcons.policyChanges,
          title: l10n.privacyChangesTitle,
          body: l10n.privacyChangesBody,
        ),
      ],
    );
  }
}
