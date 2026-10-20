import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../../../../core/widgets/display/avatar_initials.dart';
import '../../../../core/widgets/display/status_chip.dart';

class GalleryDisplaySection extends StatelessWidget {
  const GalleryDisplaySection({super.key});

  static const int _bdtMinor = 12345678;
  static const int _jpyMinor = 150000;
  static const List<String> _names = [
    'Rahim Uddin',
    'রহিম উদ্দিন',
    'ক্ষমা রায়',
    'Ayesha',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        const AmountText(
          minor: _bdtMinor,
          currencyCode: 'BDT',
          size: AmountTextSize.lg,
        ),
        const AmountText(minor: _jpyMinor, currencyCode: 'JPY'),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            StatusChip(label: l10n.statusDraft, tone: StatusTone.neutral),
            StatusChip(label: l10n.statusSent, tone: StatusTone.info),
            StatusChip(
              label: l10n.statusPartiallyPaid,
              tone: StatusTone.warning,
            ),
            StatusChip(label: l10n.statusPaid, tone: StatusTone.success),
            StatusChip(label: l10n.statusOverdue, tone: StatusTone.danger),
          ],
        ),
        Wrap(
          spacing: AppSpacing.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final name in _names) AvatarInitials(name: name),
            const AvatarInitials(name: 'Rahim Uddin', size: AppSizes.avatarLg),
          ],
        ),
      ],
    );
  }
}
