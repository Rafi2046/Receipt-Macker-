import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';

/// Semantic tones. Invoice status maps to these in the invoices feature:
/// draft = neutral, sent = info, partially paid = warning, paid = success,
/// overdue = danger.
enum StatusTone { neutral, info, warning, success, danger }

/// Outlined label in a status color. Always shows text, never color alone.
/// Outlined (no tint fill) keeps every tone above WCAG AA on the surface.
class StatusChip extends StatelessWidget {
  const StatusChip({required this.label, required this.tone, super.key});

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final color = switch (tone) {
      StatusTone.neutral => c.neutral,
      StatusTone.info => c.info,
      StatusTone.warning => c.warning,
      StatusTone.success => c.success,
      StatusTone.danger => c.danger,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.chip,
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: context.textStyles.labelMedium?.copyWith(color: color),
        ),
      ),
    );
  }
}
