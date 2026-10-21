import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_scope.dart';
import '../studio_status.dart';

/// Status shown as a tinted pill with a word, never color alone.
class StudioStatusChip extends StatelessWidget {
  const StudioStatusChip({required this.status, super.key});

  final StudioStatus status;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final l10n = context.l10n;
    final (label, color) = switch (status) {
      StudioStatus.paid => (l10n.statusPaid, palette.paid),
      StudioStatus.partial => (l10n.statusPartiallyPaid, palette.partial),
      StudioStatus.overdue => (l10n.statusOverdue, palette.overdue),
      StudioStatus.draft => (l10n.statusDraft, palette.draft),
      StudioStatus.sent => (l10n.statusSent, palette.sent),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.wash(color),
        borderRadius: AppRadius.chip,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(label, style: context.studioType.label(color)),
      ),
    );
  }
}
