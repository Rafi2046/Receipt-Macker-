import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_opacity.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../home_snapshot.dart';

/// Outstanding hero: dark panel (not full coral wash), brand only as accent.
class HomeHeroCard extends StatelessWidget {
  const HomeHeroCard({required this.snapshot, super.key});

  final HomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final money = format.currency(
      snapshot.outstandingMinor,
      snapshot.currencyCode,
    );
    final collectionProgress = snapshot.invoicedMinor > 0
        ? (snapshot.receivedMinor / snapshot.invoicedMinor).clamp(0.0, 1.0)
        : (snapshot.outstandingMinor == 0 ? 1.0 : 0.0);

    // Always a dark financial panel so light theme isn't a coral flood.
    final panel = colors.textPrimary;
    final onPanel = colors.surface;
    final onPanelMuted = colors.textSecondary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: panel,
        borderRadius: AppRadius.card,
        border: Border(left: BorderSide(color: colors.primary, width: 3)),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimary.withValues(alpha: AppOpacity.shadow),
            blurRadius: AppSpacing.xl,
            offset: const Offset(0, AppSpacing.sm),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.statOutstanding,
                        style: context.textStyles.labelMedium?.copyWith(
                          color: onPanelMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          money,
                          style: context.textStyles.displaySmall?.copyWith(
                            color: onPanel,
                            fontWeight: FontWeight.bold,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _StatusPill(snapshot: snapshot, format: format),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: AppRadius.chip,
              child: LinearProgressIndicator(
                value: collectionProgress,
                minHeight: 4,
                backgroundColor: onPanel.withValues(alpha: 0.12),
                color: colors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.homeThisMonth,
              style: context.textStyles.labelSmall?.copyWith(
                color: onPanelMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.snapshot, required this.format});

  final HomeSnapshot snapshot;
  final AppFormatters format;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    if (snapshot.overdueCount > 0) {
      return _Pill(
        icon: AppIcons.warning,
        label: '${format.integer(snapshot.overdueCount)} ${l10n.statusOverdue}',
        foreground: colors.onDanger,
        background: colors.danger,
      );
    }
    final settled = snapshot.outstandingMinor == 0;
    return _Pill(
      icon: AppIcons.success,
      label: settled ? l10n.homeAllSettled : l10n.homeUpToDate,
      foreground: colors.surface,
      background: colors.success,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.label,
    required this.foreground,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.chip,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: context.textStyles.labelSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
