import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import 'direction_palette.dart';

/// Fake invoice editor. Layout changes with the direction; data does not.
class DirectionEditorPreview extends StatelessWidget {
  const DirectionEditorPreview({
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
    final boxed = kind != DirectionKind.ledger;
    return ColoredBox(
      color: palette.background,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          _field(
            context,
            context.l10n.fieldInvoiceNumber,
            _m(context, 'INV-0001'),
            boxed,
          ),
          _field(
            context,
            context.l10n.fieldIssueDate,
            _m(context, '20 Oct 2026'),
            boxed,
          ),
          _field(context, context.l10n.sectionBillTo, 'Karim Store', boxed),
          const SizedBox(height: AppSpacing.lg),
          Text(
            context.l10n.itemsTitle,
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(color: palette.muted),
          ),
          _line(context, 'Logo design', _m(context, '৳5,000')),
          _line(context, 'Consulting', _m(context, '৳2,700')),
          const SizedBox(height: AppSpacing.lg),
          _total(context),
        ],
      ),
    );
  }

  Widget _field(BuildContext context, String label, String value, bool boxed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: boxed ? palette.surface : null,
          borderRadius: BorderRadius.circular(palette.radius),
          border: Border(
            bottom: BorderSide(color: palette.line),
            top: boxed ? BorderSide(color: palette.line) : BorderSide.none,
            left: boxed ? BorderSide(color: palette.line) : BorderSide.none,
            right: boxed ? BorderSide(color: palette.line) : BorderSide.none,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(color: palette.muted),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: palette.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _line(BuildContext context, String name, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
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
        ],
      ),
    );
  }

  Widget _total(BuildContext context) {
    final fill = kind == DirectionKind.current;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: fill ? palette.accent : palette.surface,
        borderRadius: BorderRadius.circular(palette.radius),
        border: fill ? null : Border.all(color: palette.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.totalTotal,
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(color: fill ? palette.onAccent : palette.muted),
            ),
          ),
          Text(
            _m(context, '৳8,637'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: fill ? palette.onAccent : palette.ink,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
