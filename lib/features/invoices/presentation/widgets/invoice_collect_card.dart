import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/inputs/segmented_choice.dart';
import '../../../../core/widgets/layout/app_card.dart';

/// Unpaid (credit) vs Paid now (cash) — Save records a full payment when
/// Paid now is selected.
class InvoiceCollectCard extends StatelessWidget {
  const InvoiceCollectCard({
    required this.markPaidOnSave,
    required this.onChanged,
    super.key,
  });

  final bool markPaidOnSave;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          Row(
            spacing: AppSpacing.sm,
            children: [
              Icon(
                AppIcons.payment,
                size: AppSizes.iconSm,
                color: context.appColors.textSecondary,
              ),
              Expanded(
                child: Text(
                  l10n.editorCollectPayment,
                  style: context.textStyles.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SegmentedChoice<bool>(
            value: markPaidOnSave,
            options: [
              (false, l10n.editorCollectUnpaid),
              (true, l10n.editorCollectPaidNow),
            ],
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
