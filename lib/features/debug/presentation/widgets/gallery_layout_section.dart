import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../../../../core/widgets/display/avatar_initials.dart';
import '../../../../core/widgets/display/status_chip.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/app_divider.dart';
import '../../../../core/widgets/layout/section_header.dart';

/// Section header plus a card shaped like a future invoice list row.
class GalleryLayoutSection extends StatelessWidget {
  const GalleryLayoutSection({super.key});

  static const int _sampleMinor = 1245000;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: l10n.galleryRecentInvoices,
          actionLabel: l10n.gallerySeeAll,
          onAction: () {},
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          onTap: () {},
          child: Column(
            children: [
              _SampleRow(
                status: StatusChip(
                  label: l10n.statusPaid,
                  tone: StatusTone.success,
                ),
              ),
              const AppDivider(),
              _SampleRow(
                status: StatusChip(
                  label: l10n.statusOverdue,
                  tone: StatusTone.danger,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SampleRow extends StatelessWidget {
  const _SampleRow({required this.status});

  final Widget status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        AvatarInitials(name: l10n.gallerySampleClient),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.gallerySampleClient,
                style: context.textStyles.titleSmall,
              ),
              Text(
                l10n.gallerySampleInvoice,
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.appColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: AppSpacing.xs,
              children: [
                const AmountText(
                  minor: GalleryLayoutSection._sampleMinor,
                  currencyCode: 'BDT',
                  alignment: AlignmentDirectional.centerEnd,
                ),
                status,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
