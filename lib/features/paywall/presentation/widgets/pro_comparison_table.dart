import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/gen/app_localizations.dart';

/// Free versus Pro. The client/item cap comes from [AppConstants.freeRecordLimit].
class ProComparisonTable extends StatelessWidget {
  const ProComparisonTable({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final count = AppFormatters(Localizations.localeOf(context).languageCode)
        .integer(AppConstants.freeRecordLimit);
    final rows = _rows(l10n, count);
    final header = context.textStyles.labelMedium?.copyWith(
      color: context.appColors.textSecondary,
    );
    return Column(
      children: [
        _Line(
          feature: l10n.proCompareFeature,
          free: l10n.proCompareFree,
          pro: l10n.proComparePro,
          style: header,
        ),
        for (final row in rows) ...[
          const SizedBox(height: AppSpacing.md),
          _Line(feature: row.$1, free: row.$2, pro: row.$3),
        ],
      ],
    );
  }

  List<(String, String, String)> _rows(AppLocalizations l10n, String count) => [
    (l10n.proRowInvoices, l10n.proRowUnlimited, l10n.proRowUnlimited),
    (l10n.proRowTemplates, l10n.proRowTemplatesFree, l10n.proRowTemplatesPro),
    (l10n.proRowLogo, l10n.proRowYes, l10n.proRowYes),
    (l10n.proRowFooter, l10n.proRowFooterFree, l10n.proRowFooterPro),
    (l10n.proRowClients, l10n.proRowClientsFree(count), l10n.proRowClientsPro),
    (l10n.proRowBackup, l10n.proRowBackupFree, l10n.proRowBackupPro),
    (l10n.proRowAds, l10n.proRowAdsFree, l10n.proRowAdsPro),
  ];
}

class _Line extends StatelessWidget {
  const _Line({
    required this.feature,
    required this.free,
    required this.pro,
    this.style,
  });

  final String feature;
  final String free;
  final String pro;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final text = style ?? context.textStyles.bodyMedium;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: Text(feature, style: text)),
        Expanded(
          child: Text(free, style: text, textAlign: TextAlign.end),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(pro, style: text, textAlign: TextAlign.end),
        ),
      ],
    );
  }
}
