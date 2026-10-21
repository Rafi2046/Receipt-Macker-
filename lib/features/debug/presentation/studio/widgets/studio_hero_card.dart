import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_money.dart';
import '../studio_scope.dart';
import '../studio_snapshot.dart';
import 'studio_count_up.dart';

/// Deep green summary: outstanding, invoiced, received, and the month change.
class StudioHeroCard extends StatelessWidget {
  const StudioHeroCard({required this.snapshot, super.key});

  final StudioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.xxl),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [palette.heroStart, palette.heroEnd],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              right: -AppSpacing.xxl,
              top: -AppSpacing.xxxl,
              child: _Glow(),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: _HeroBody(snapshot: snapshot),
            ),
          ],
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.logoMd * 2,
      height: AppSizes.logoMd * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.studio.heroGlow,
      ),
    );
  }
}

class _HeroBody extends StatelessWidget {
  const _HeroBody({required this.snapshot});

  final StudioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final type = context.studioType;
    final l10n = context.l10n;
    final change = studioSignedPercent(context, snapshot.changePercent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.statOutstanding, style: type.label(palette.onHeroMuted)),
        const SizedBox(height: AppSpacing.xs),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: StudioCountUp(
            minor: snapshot.outstandingMinor,
            style: type.display(palette.onHero),
            format: (minor) => studioMoney(context, minor),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: _MiniStat(
                label: l10n.statInvoiced,
                minor: snapshot.invoicedMinor,
              ),
            ),
            Expanded(
              child: _MiniStat(
                label: l10n.statReceived,
                minor: snapshot.receivedMinor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        DecoratedBox(
          decoration: BoxDecoration(
            color: palette.heroPill,
            borderRadius: AppRadius.chip,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Text(
              '$change ${l10n.studioVsLastMonth}',
              style: type.label(palette.onHero),
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.minor});

  final String label;
  final int minor;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final type = context.studioType;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: type.label(palette.onHeroMuted)),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          studioMoney(context, minor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: type.amount(palette.onHero),
        ),
      ],
    );
  }
}
