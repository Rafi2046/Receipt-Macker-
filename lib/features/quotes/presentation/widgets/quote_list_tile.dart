import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../../../../core/widgets/display/avatar_initials.dart';
import '../../../../core/widgets/display/status_chip.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../domain/logic/quote_status_resolver.dart';
import '../../domain/models/quote_status.dart';
import '../../domain/models/quote_summary.dart';

/// One estimate as a card, laid out like an invoice card: client and total
/// on top, number + valid-until date and status below.
class QuoteListTile extends StatelessWidget {
  const QuoteListTile({required this.summary, required this.onTap, super.key});

  final QuoteSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final client = summary.clientName ?? l10n.noClient;
    final overdue = QuoteStatusResolver.isOverdue(
      summary.status,
      summary.validUntil,
    );
    final (label, tone) = overdue
        ? (l10n.filterOverdue, StatusTone.danger)
        : switch (summary.status) {
            QuoteStatus.pending => (
              l10n.quoteStatusPending,
              StatusTone.warning,
            ),
            QuoteStatus.approved => (
              l10n.quoteStatusApproved,
              StatusTone.success,
            ),
            QuoteStatus.rejected => (
              l10n.quoteStatusCancelled,
              StatusTone.neutral,
            ),
          };
    final meta =
        '${format.localizeDigits(summary.number)}  ·  '
        '${l10n.quoteValidUntil(format.calendarDate(summary.validUntil))}';
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          AvatarInitials(name: client),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Row(
                  spacing: AppSpacing.md,
                  children: [
                    Expanded(
                      child: Text(
                        client,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    AmountText(
                      minor: summary.totalMinor,
                      currencyCode: summary.currencyCode,
                    ),
                  ],
                ),
                Row(
                  spacing: AppSpacing.md,
                  children: [
                    Expanded(
                      child: Text(
                        meta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.bodySmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                    StatusChip(label: label, tone: tone),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
