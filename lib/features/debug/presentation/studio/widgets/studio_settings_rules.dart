import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import 'studio_choice_row.dart';
import 'studio_settings_field.dart';
import 'studio_settings_heading.dart';
import 'studio_toggle_row.dart';

/// Toggles and invoice-number rules.
class StudioSettingsRules extends StatelessWidget {
  const StudioSettingsRules({
    required this.prefix,
    required this.next,
    required this.paidStamp,
    required this.totalQty,
    required this.balance,
    required this.splitQty,
    required this.resetYearly,
    required this.onPaidStamp,
    required this.onTotalQty,
    required this.onBalance,
    required this.onSplitQty,
    required this.onReset,
    super.key,
  });

  final TextEditingController prefix;
  final TextEditingController next;
  final bool paidStamp;
  final bool totalQty;
  final bool balance;
  final bool splitQty;
  final bool resetYearly;
  final ValueChanged<bool> onPaidStamp;
  final ValueChanged<bool> onTotalQty;
  final ValueChanged<bool> onBalance;
  final ValueChanged<bool> onSplitQty;
  final ValueChanged<int> onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudioSettingsHeading(l10n.studioOnInvoice),
        StudioToggleRow(
          label: l10n.studioShowPaidStamp,
          value: paidStamp,
          onChanged: onPaidStamp,
        ),
        const SizedBox(height: AppSpacing.sm),
        StudioToggleRow(
          label: l10n.studioShowTotalQty,
          value: totalQty,
          onChanged: onTotalQty,
        ),
        const SizedBox(height: AppSpacing.sm),
        StudioToggleRow(
          label: l10n.studioShowBalanceDue,
          value: balance,
          onChanged: onBalance,
        ),
        const SizedBox(height: AppSpacing.sm),
        StudioToggleRow(
          label: l10n.studioShowQtyUnit,
          value: splitQty,
          onChanged: onSplitQty,
        ),
        const SizedBox(height: AppSpacing.lg),
        StudioSettingsHeading(l10n.studioNumberRules),
        StudioSettingsField(label: l10n.studioNumberPrefix, controller: prefix),
        const SizedBox(height: AppSpacing.sm),
        StudioSettingsField(
          label: l10n.studioNumberNext,
          controller: next,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.sm),
        StudioSettingsHeading(l10n.studioNumberReset),
        StudioChoiceRow(
          labels: [l10n.studioResetYearly, l10n.studioResetNever],
          selected: resetYearly ? 0 : 1,
          onSelected: onReset,
        ),
      ],
    );
  }
}
