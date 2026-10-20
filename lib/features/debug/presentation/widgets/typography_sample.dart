import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';

/// Every text role with a sample sentence, plus Bangla conjuncts.
class TypographySample extends StatelessWidget {
  const TypographySample({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.textStyles;
    final sample = context.l10n.typographySample;
    final roles = [
      t.displaySmall,
      t.titleLarge,
      t.titleMedium,
      t.bodyLarge,
      t.bodyMedium,
      t.bodySmall,
      t.labelMedium,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.conjunctSample,
          style: t.displaySmall?.copyWith(color: context.appColors.primary),
        ),
        for (final style in roles)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(sample, style: style),
          ),
      ],
    );
  }
}
