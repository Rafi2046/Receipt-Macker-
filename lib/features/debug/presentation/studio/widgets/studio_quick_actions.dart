import 'package:flutter/material.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_icons.dart';
import '../studio_scope.dart';

/// Four round actions under the hero.
class StudioQuickActions extends StatelessWidget {
  const StudioQuickActions({
    required this.onNewInvoice,
    required this.onRecordPayment,
    required this.onAddClient,
    required this.onAddItem,
    super.key,
  });

  final VoidCallback onNewInvoice;
  final VoidCallback onRecordPayment;
  final VoidCallback onAddClient;
  final VoidCallback onAddItem;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Action(
          icon: StudioIcons.add,
          label: l10n.invoiceNewTitle,
          onTap: onNewInvoice,
        ),
        _Action(
          icon: StudioIcons.payment,
          label: l10n.recordPayment,
          onTap: onRecordPayment,
        ),
        _Action(
          icon: AppIcons.client,
          label: l10n.studioAddClient,
          onTap: onAddClient,
        ),
        _Action(
          icon: StudioIcons.items,
          label: l10n.studioAddItem,
          onTap: onAddItem,
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            children: [
              Container(
                width: AppSizes.minTapTarget,
                height: AppSizes.minTapTarget,
                decoration: BoxDecoration(
                  color: palette.wash(palette.accent),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: palette.accent, size: AppSizes.iconMd),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.studioType.label(palette.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
