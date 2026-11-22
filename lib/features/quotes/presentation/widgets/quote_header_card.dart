import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/calendar_date.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/inputs/currency_picker_field.dart';
import '../../../../core/widgets/inputs/date_field.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../domain/models/quote.dart';
import '../view_models/quote_editor_view_model.dart';

/// Tappable summary of number + valid-until; opens details sheet.
class QuoteHeaderCard extends StatelessWidget {
  const QuoteHeaderCard({required this.draft, required this.vm, super.key});

  final Quote draft;
  final QuoteEditorViewModel vm;

  Future<void> _openDetails(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _QuoteDetailsSheet(draft: draft, vm: vm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    return AppCard(
      onTap: () => _openDetails(context),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  draft.number,
                  style: context.textStyles.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.quoteValidUntil(format.calendarDate(draft.validUntil)),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(AppIcons.chevronRight, color: colors.textSecondary),
        ],
      ),
    );
  }
}

class _QuoteDetailsSheet extends StatelessWidget {
  const _QuoteDetailsSheet({required this.draft, required this.vm});

  final Quote draft;
  final QuoteEditorViewModel vm;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.pagePadding,
        right: AppSpacing.pagePadding,
        top: AppSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.quoteHeaderDetails,
            style: context.textStyles.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: l10n.fieldInvoiceNumber,
            initialValue: draft.number,
            onChanged: vm.setNumber,
          ),
          const SizedBox(height: AppSpacing.sm),
          DateField(
            label: l10n.fieldIssueDate,
            value: draft.issueDate.toLocalDateTime(),
            onChanged: (d) => vm.setIssueDate(CalendarDate.fromLocal(d)),
          ),
          const SizedBox(height: AppSpacing.sm),
          DateField(
            label: l10n.fieldDueDate,
            value: draft.validUntil.toLocalDateTime(),
            onChanged: (d) => vm.setValidUntil(CalendarDate.fromLocal(d)),
          ),
          const SizedBox(height: AppSpacing.sm),
          CurrencyPickerField(
            label: l10n.fieldCurrency,
            value: draft.currencyCode,
            codes: {...AppCurrencies.common, draft.currencyCode}.toList(),
            onChanged: vm.setCurrency,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
