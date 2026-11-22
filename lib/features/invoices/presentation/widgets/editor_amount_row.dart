import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/display/amount_text.dart';

/// A label with an amount on the right; [strong] for the total.
class EditorAmountRow extends StatelessWidget {
  const EditorAmountRow({
    required this.label,
    required this.minor,
    required this.currencyCode,
    this.strong = false,
    super.key,
  });

  final String label;
  final int minor;
  final String currencyCode;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          Expanded(
            child: Text(
              label,
              style: (strong ? text.titleMedium : text.titleSmall)?.copyWith(
                fontWeight: strong ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
          AmountText(
            minor: minor,
            currencyCode: currencyCode,
            size: strong ? AmountTextSize.lg : AmountTextSize.md,
            alignment: AlignmentDirectional.centerEnd,
          ),
        ],
      ),
    );
  }
}
