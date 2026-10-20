import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/display/avatar_initials.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../domain/models/bill_to.dart';

/// Who the invoice is for. Without a client it offers "Choose a client";
/// with one it shows the copied details and Change / Remove. Read-only when
/// both callbacks are null (invoice detail).
class BillToCard extends StatelessWidget {
  const BillToCard({
    required this.billTo,
    this.onChoose,
    this.onRemove,
    super.key,
  });

  final BillTo? billTo;
  final VoidCallback? onChoose;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bill = billTo;
    final choose = onChoose;
    if (bill == null) {
      return AppCard(
        onTap: choose,
        child: Row(
          spacing: AppSpacing.md,
          children: [
            Icon(AppIcons.client, color: context.appColors.primary),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    choose == null ? l10n.noClient : l10n.chooseClient,
                    style: context.textStyles.titleSmall,
                  ),
                  if (choose != null)
                    Text(
                      l10n.chooseClientHint,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            if (choose != null)
              Icon(
                AppIcons.chevronRight,
                color: context.appColors.textSecondary,
              ),
          ],
        ),
      );
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          _Details(billTo: bill),
          if (choose != null || onRemove != null)
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                if (choose != null)
                  AppButton(
                    label: l10n.change,
                    variant: AppButtonVariant.text,
                    onPressed: choose,
                  ),
                if (onRemove != null)
                  AppButton(
                    label: l10n.remove,
                    variant: AppButtonVariant.text,
                    onPressed: onRemove,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.billTo});

  final BillTo billTo;

  @override
  Widget build(BuildContext context) {
    final digits = AppFormatters(Localizations.localeOf(context).languageCode);
    final contact = digits.localizeDigits(
      [billTo.phone, billTo.email].where((s) => s.isNotEmpty).join(' · '),
    );
    final secondary = context.textStyles.bodySmall?.copyWith(
      color: context.appColors.textSecondary,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        AvatarInitials(name: billTo.name),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(billTo.name, style: context.textStyles.titleSmall),
              if (contact.isNotEmpty) Text(contact, style: secondary),
              if (billTo.address.isNotEmpty)
                Text(billTo.address, style: secondary),
            ],
          ),
        ),
      ],
    );
  }
}
