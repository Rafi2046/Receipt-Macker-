import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/purchases/free_plan.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/layout/app_card.dart';

/// Free versus Pro, with the Pro column lifted. Limits and template counts
/// come from [AppConstants] and [FreePlan], never typed by hand.
class ProComparisonTable extends StatelessWidget {
  const ProComparisonTable({super.key});

  /// Marks a cell that shows a check (true) or a cross (false).
  static const String _yes = '✓';
  static const String _no = '✗';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final limits =
        '${format.integer(AppConstants.freeClientLimit)} / '
        '${format.integer(AppConstants.freeItemLimit)}';
    final rows = <(String, String, String)>[
      (l10n.proRowInvoices, _yes, _yes),
      (
        l10n.proRowTemplates,
        l10n.proRowTemplatesFree(format.integer(FreePlan.freeTemplateCount)),
        l10n.proRowTemplatesPro(format.integer(FreePlan.templateCount)),
      ),
      (l10n.proRowLogo, _yes, _yes),
      (l10n.proRowColors, l10n.proRowColorsFree, _yes),
      (
        l10n.proRowClients,
        l10n.proRowClientsFree(limits),
        l10n.proRowUnlimited,
      ),
      (l10n.proRowFooter, l10n.proRowFooterFree, l10n.proRowFooterPro),
      (l10n.proRowAds, l10n.proRowAdsFree, l10n.proRowAdsPro),
      (l10n.proRowBackup, _yes, _yes),
    ];
    final head = context.textStyles.labelLarge?.copyWith(
      fontWeight: FontWeight.w800,
    );
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        children: [
          _Line(
            feature: Text(l10n.proCompareFeature, style: head),
            free: Text(l10n.proCompareFree, style: head),
            pro: Text(
              l10n.proComparePro.toUpperCase(),
              style: head?.copyWith(color: context.appColors.primary),
            ),
          ),
          for (final (feature, free, pro) in rows)
            _Line(
              feature: Text(feature, style: context.textStyles.bodyMedium),
              free: _Cell(free, pro: false),
              pro: _Cell(pro, pro: true),
            ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.value, {required this.pro});

  final String value;
  final bool pro;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (value == ProComparisonTable._yes) {
      return Icon(
        AppIcons.check,
        size: AppSizes.iconRow,
        color: colors.success,
      );
    }
    if (value == ProComparisonTable._no) {
      return Icon(AppIcons.close, size: AppSizes.iconRow, color: colors.danger);
    }
    return Text(
      value,
      textAlign: TextAlign.center,
      style: context.textStyles.labelMedium?.copyWith(
        color: pro ? colors.textPrimary : colors.textSecondary,
        fontWeight: pro ? FontWeight.w700 : FontWeight.w500,
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.feature, required this.free, required this.pro});

  final Widget feature;
  final Widget free;
  final Widget pro;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: feature,
              ),
            ),
          ),
          Expanded(flex: 3, child: Center(child: free)),
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              color: colors.primary.withValues(alpha: 0.06),
              alignment: Alignment.center,
              child: pro,
            ),
          ),
        ],
      ),
    );
  }
}
