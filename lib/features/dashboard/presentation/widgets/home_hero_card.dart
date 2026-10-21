import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../home_snapshot.dart';

/// Outstanding amount, with this month's invoiced and received beside it.
class HomeHeroCard extends StatelessWidget {
  const HomeHeroCard({required this.snapshot, super.key});

  final HomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final money = format.currency(
      snapshot.outstandingMinor,
      snapshot.currencyCode,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.heroStart, colors.heroEnd],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.statOutstanding,
              style: context.textStyles.labelLarge?.copyWith(
                color: colors.onHeroMuted,
              ),
            ),
            Text(
              money,
              style: context.textStyles.displaySmall?.copyWith(
                color: colors.onHero,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.homeThisMonth,
              style: context.textStyles.labelMedium?.copyWith(
                color: colors.onHeroMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: _Stat(
                    label: context.l10n.homeStatInvoiced,
                    value: format.currency(
                      snapshot.invoicedMinor,
                      snapshot.currencyCode,
                    ),
                  ),
                ),
                Expanded(
                  child: _Stat(
                    label: context.l10n.statReceived,
                    value: format.currency(
                      snapshot.receivedMinor,
                      snapshot.currencyCode,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textStyles.labelMedium?.copyWith(
            color: colors.onHeroMuted,
          ),
        ),
        Text(
          value,
          style: context.textStyles.titleMedium?.copyWith(
            color: colors.onHero,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
