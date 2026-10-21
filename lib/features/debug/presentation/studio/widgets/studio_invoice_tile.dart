import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../studio_invoice.dart';
import '../studio_money.dart';
import '../studio_scope.dart';
import '../studio_status.dart';
import 'studio_avatar.dart';
import 'studio_status_chip.dart';

/// Client, number, due label, amount, and a status chip.
class StudioInvoiceTile extends StatelessWidget {
  const StudioInvoiceTile({required this.invoice, super.key, this.onTap});

  final StudioInvoice invoice;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final type = context.studioType;
    final number = studioFormat(context).localizeDigits(invoice.number);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            StudioAvatar(name: invoice.client),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _Copy(invoice: invoice, number: number),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  studioMoney(context, invoice.totalMinor),
                  style: type.amount(palette.ink),
                ),
                const SizedBox(height: AppSpacing.xs),
                StudioStatusChip(status: invoice.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Copy extends StatelessWidget {
  const _Copy({required this.invoice, required this.number});

  final StudioInvoice invoice;
  final String number;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final type = context.studioType;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          invoice.client,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: type.titleSm(palette.ink),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          invoice.status == StudioStatus.paid
              ? number
              : '$number · ${studioDueLabel(context, invoice.dueInDays)}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: type.secondary(palette.muted),
        ),
      ],
    );
  }
}
