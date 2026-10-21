import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../../../../core/widgets/display/avatar_initials.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../view_models/invoice_list_state.dart';
import 'invoice_status_chip.dart';

/// One invoice as a card: client and total on top, number + due date and
/// status below. Start cells share a left edge, end cells a right edge.
class InvoiceListTile extends StatelessWidget {
  const InvoiceListTile({required this.entry, required this.onTap, super.key});

  final InvoiceListEntry entry;
  final VoidCallback onTap;

  /// Most of a row the amount or status may take.
  static const double _endShare = 0.5;

  @override
  Widget build(BuildContext context) {
    final s = entry.summary;
    final client = s.clientName ?? context.l10n.noClient;
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
              spacing: AppSpacing.xs,
              children: [
                _GridRow(
                  start: Text(
                    client,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  end: AmountText(
                    minor: s.totalMinor,
                    currencyCode: s.currencyCode,
                    alignment: AlignmentDirectional.centerEnd,
                  ),
                ),
                _GridRow(
                  start: _Meta(entry: entry),
                  end: InvoiceStatusChip(status: entry.status),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A start cell pinned to the left edge and an end cell pinned to the
/// right edge. The end cell takes only the width it needs (at most half),
/// so the start text keeps as much room as possible.
class _GridRow extends StatelessWidget {
  const _GridRow({required this.start, required this.end});

  final Widget start;
  final Widget end;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        spacing: AppSpacing.md,
        children: [
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: start,
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * InvoiceListTile._endShare,
            ),
            child: end,
          ),
        ],
      ),
    );
  }
}

/// "INV-0002 • Due Oct 28, 2026" in muted type.
class _Meta extends StatelessWidget {
  const _Meta({required this.entry});

  final InvoiceListEntry entry;

  @override
  Widget build(BuildContext context) {
    final s = entry.summary;
    final colors = context.appColors;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final muted = context.textStyles.bodySmall?.copyWith(
      color: colors.textSecondary,
    );
    // One text run: it fills left to right and only cuts at the very end,
    // so the date shows whenever there is room.
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: format.localizeDigits(s.number)),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Container(
                width: AppSpacing.xs,
                height: AppSpacing.xs,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.textSecondary,
                ),
              ),
            ),
          ),
          TextSpan(
            text: context.l10n.invoiceDueOn(format.calendarDate(s.dueDate)),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: muted,
    );
  }
}
