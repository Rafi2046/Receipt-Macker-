import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/app_divider.dart';
import '../../../../core/widgets/layout/section_header.dart';
import '../../../payments/presentation/widgets/invoice_payments_section.dart';
import '../view_models/invoice_detail_state.dart';
import 'bill_to_card.dart';
import 'invoice_detail_header.dart';
import 'line_item_row.dart';
import 'totals_summary.dart';

/// Read-only invoice: header, bill to, lines, totals and notes.
class InvoiceDetailBody extends StatelessWidget {
  const InvoiceDetailBody({
    required this.state,
    required this.onPreview,
    super.key,
  });

  final InvoiceDetailState state;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final invoice = state.invoice;
    final notes = [
      (l10n.fieldNotes, invoice.notes),
      (l10n.fieldTerms, invoice.terms),
      (l10n.fieldPaymentInstructions, invoice.paymentInstructions),
    ].where((n) => n.$2.trim().isNotEmpty).toList();
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      children: [
        InvoiceDetailHeader(state: state),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: l10n.previewAndShare,
          icon: AppIcons.pdf,
          expand: true,
          onPressed: onPreview,
        ),
        _Header(title: l10n.sectionBillTo),
        BillToCard(billTo: invoice.billTo),
        _Header(title: l10n.itemsTitle),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              for (final (i, line) in invoice.lines.indexed) ...[
                if (i > 0) const AppDivider(spacing: AppSpacing.xxs),
                LineItemRow(
                  line: line,
                  totals: state.totals.lines[i],
                  currencyCode: invoice.currencyCode,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TotalsSummary(
          totals: state.totals,
          taxRateBasisPoints: invoice.taxRateBasisPoints,
          taxInclusive: invoice.taxInclusive,
        ),
        InvoicePaymentsSection(state: state),
        for (final (label, text) in notes) ...[
          _Header(title: label),
          Text(text, style: context.textStyles.bodyMedium),
        ],
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: AppSpacing.sectionGap,
      bottom: AppSpacing.sm,
    ),
    child: SectionHeader(title: title),
  );
}
