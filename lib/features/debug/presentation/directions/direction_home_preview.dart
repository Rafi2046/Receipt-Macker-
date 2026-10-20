import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import 'direction_palette.dart';
import 'direction_status.dart';

/// Fake Home for one proposed direction. Numbers are sample copy.
class DirectionHomePreview extends StatelessWidget {
  const DirectionHomePreview({
    required this.kind,
    required this.palette,
    super.key,
  });

  final DirectionKind kind;
  final DirectionPalette palette;

  String _m(BuildContext context, String text) =>
      AppFormatters(context.l10n.localeName).localizeDigits(text);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: palette.background,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          if (kind == DirectionKind.atelier) _greeting(context),
          Text(
            context.l10n.previewMonth,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(color: palette.ink, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (palette.filledHero) _hero(context) else _figures(context),
          const SizedBox(height: AppSpacing.md),
          _banner(context),
          const SizedBox(height: AppSpacing.xl),
          _row(
            context,
            'Karim Store',
            _m(context, '৳8,637'),
            context.l10n.statusPaid,
            palette.paid,
          ),
          _row(
            context,
            'Rahman & Sons',
            _m(context, '৳18,200'),
            context.l10n.statusDraft,
            palette.draft,
          ),
        ],
      ),
    );
  }

  Widget _greeting(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
    child: Text(
      context.l10n.greetingEvening,
      style: Theme.of(context).textTheme.bodyMedium
          ?.copyWith(color: palette.muted),
    ),
  );

  Widget _figures(BuildContext context) {
    return Row(
      children: [
        _stat(context, context.l10n.statInvoiced, _m(context, '৳48,000')),
        _stat(context, context.l10n.statReceived, _m(context, '৳21,500')),
        _stat(context, context.l10n.statOutstanding, _m(context, '৳26,500')),
      ],
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: palette.accent,
        borderRadius: BorderRadius.circular(palette.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.statOutstanding,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(color: palette.onAccent.withValues(alpha: 0.8)),
          ),
          Text(
            _m(context, '৳26,500'),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: palette.onAccent,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String label, String amount) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: palette.muted),
          ),
          Text(
            amount,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: palette.ink,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _banner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: palette.wash(palette.overdue),
        borderRadius: BorderRadius.circular(palette.radius),
        border: palette.softShadow
            ? null
            : Border(
                left: BorderSide(
                  color: palette.overdue,
                  width: AppSizes.selectedBorderWidth,
                ),
              ),
      ),
      child: Text(
        context.l10n.overdueBannerPreview,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: palette.overdue, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String name,
    String amount,
    String status,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: palette.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: palette.ink),
            ),
          ),
          Text(
            amount,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: palette.ink,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          DirectionStatus(label: status, color: color, palette: palette),
        ],
      ),
    );
  }
}
