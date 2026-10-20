import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';

/// Invoice status colors, always with their text label.
/// The real StatusChip is built in M1.
class StatusLabelRow extends StatelessWidget {
  const StatusLabelRow({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final l10n = context.l10n;
    final statuses = [
      (l10n.statusDraft, c.neutral),
      (l10n.statusSent, c.info),
      (l10n.statusPartiallyPaid, c.warning),
      (l10n.statusPaid, c.success),
      (l10n.statusOverdue, c.danger),
    ];
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final (label, color) in statuses)
          _StatusLabel(label: label, color: color),
      ],
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.chip,
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          label,
          style: context.textStyles.labelMedium?.copyWith(color: color),
        ),
      ),
    );
  }
}
