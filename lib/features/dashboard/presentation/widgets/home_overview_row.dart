import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../home_snapshot.dart';

/// Three compact stats under the hero: Received, Outstanding, Overdue.
class HomeOverviewRow extends StatelessWidget {
  const HomeOverviewRow({required this.snapshot, super.key});

  final HomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final code = snapshot.currencyCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeOverview,
          style: context.textStyles.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _OverviewTile(
                label: l10n.statReceived,
                value: format.currency(snapshot.receivedMinor, code),
                valueColor: colors.success,
                onTap: () => context.goNamed(RouteNames.invoices),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _OverviewTile(
                label: l10n.statOutstanding,
                value: format.currency(snapshot.outstandingMinor, code),
                valueColor: colors.textPrimary,
                onTap: () => context.goNamed(RouteNames.invoices),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _OverviewTile(
                label: l10n.statusOverdue,
                value: format.currency(snapshot.overdueMinor, code),
                valueColor: colors.danger,
                onTap: () => context.goNamed(RouteNames.invoices),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OverviewTile extends StatelessWidget {
  const _OverviewTile({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.onTap,
  });

  final String label;
  final String value;
  final Color valueColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: colors.surface,
      borderRadius: AppRadius.card,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppRadius.card,
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.labelSmall?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: context.textStyles.titleSmall?.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
