import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
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
        title: l10n.privacyTitle,
        intro: l10n.privacyIntro,
        note: l10n.legalUpdated(format.date(AppConstants.legalUpdatedOn)),
      ),
      sections: [
        (title: l10n.privacyLocalTitle, body: l10n.privacyLocalBody),
        (title: l10n.privacyBackupTitle, body: l10n.privacyBackupBody),
        (title: l10n.privacyAdsTitle, body: l10n.privacyAdsBody),
        (title: l10n.privacyPurchaseTitle, body: l10n.privacyPurchaseBody),
        (title: l10n.privacyAnalyticsTitle, body: l10n.privacyAnalyticsBody),
        (
          title: l10n.privacyPermissionsTitle,
          body: l10n.privacyPermissionsBody,
        ),
        (title: l10n.privacyDeleteTitle, body: l10n.privacyDeleteBody),
        (title: l10n.privacyChangesTitle, body: l10n.privacyChangesBody),
      ],
    );
  }
}
