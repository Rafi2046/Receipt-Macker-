import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_icons.dart';
import '../studio_money.dart';
import '../studio_scope.dart';
import 'studio_add_item_button.dart';
import 'studio_card.dart';
import 'studio_swipe_row.dart';

/// Items, discount, shipping, and notes for the editor mock.
class StudioEditorSections extends StatelessWidget {
  const StudioEditorSections({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ItemsCard(),
        SizedBox(height: AppSpacing.md),
        _AdjustmentsCard(),
        SizedBox(height: AppSpacing.md),
        _NotesCard(),
      ],
    );
  }
}

class _Line {
  const _Line({
    required this.name,
    required this.qty,
    required this.unit,
    required this.unitMinor,
    required this.totalMinor,
  });

  final String name;
  final int qty;
  final String unit;
  final int unitMinor;
  final int totalMinor;
}

class _ItemsCard extends StatefulWidget {
  const _ItemsCard();

  @override
  State<_ItemsCard> createState() => _ItemsCardState();
}

class _ItemsCardState extends State<_ItemsCard> {
  List<_Line>? _lines;

  List<_Line> _seed() {
    final l10n = context.l10n;
    return [
      _Line(
        name: l10n.studioItemLogo,
        qty: 1000,
        unit: 'piece',
        unitMinor: 500000,
        totalMinor: 500000,
      ),
      _Line(
        name: l10n.studioItemConsulting,
        qty: 2500,
        unit: 'hour',
        unitMinor: 120000,
        totalMinor: 270000,
      ),
      _Line(
        name: l10n.studioItemDelivery,
        qty: 1000,
        unit: 'job',
        unitMinor: 50000,
        totalMinor: 50000,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.studio;
    final lines = _lines ??= _seed();
    return StudioCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.itemsTitle, style: context.studioType.titleSm(palette.ink)),
          for (final line in lines)
            StudioSwipeRow(
              actions: [
                StudioSwipeAction(
                  icon: StudioIcons.delete,
                  label: l10n.delete,
                  color: palette.overdue,
                  onPressed: () => setState(() => lines.remove(line)),
                ),
              ],
              child: _ItemRow(
                name: line.name,
                qty: line.qty,
                unit: line.unit,
                unitMinor: line.unitMinor,
                totalMinor: line.totalMinor,
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          const StudioAddItemButton(),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.name,
    required this.qty,
    required this.unit,
    required this.unitMinor,
    required this.totalMinor,
  });

  final String name;
  final int qty;
  final String unit;
  final int unitMinor;
  final int totalMinor;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final format = studioFormat(context);
    final unitLabel = switch (unit) {
      'hour' => context.l10n.studioUnitHour,
      'job' => context.l10n.studioUnitJob,
      _ => context.l10n.studioUnitPiece,
    };
    final detail =
        '${format.quantity(qty)} $unitLabel × ${format.currency(unitMinor, 'BDT')}';
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: context.studioType.body(palette.ink)),
                Text(
                  detail,
                  style: context.studioType.secondary(palette.muted),
                ),
              ],
            ),
          ),
          Text(
            studioMoney(context, totalMinor),
            style: context.studioType.amountSm(palette.ink),
          ),
        ],
      ),
    );
  }
}

class _AdjustmentsCard extends StatelessWidget {
  const _AdjustmentsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return StudioCard(
      child: Column(
        children: [
          _MoneyRow(label: l10n.fieldDiscount, minor: -82000),
          _MoneyRow(
            label: l10n.totalTax(studioFormat(context).percent(1500)),
            minor: 110700,
          ),
          _MoneyRow(label: l10n.fieldShipping, minor: 15000),
        ],
      ),
    );
  }
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow({required this.label, required this.minor});

  final String label;
  final int minor;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: context.studioType.body(palette.muted)),
          ),
          Text(
            studioMoney(context, minor),
            style: context.studioType.amountSm(palette.ink),
          ),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return StudioCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.fieldNotes,
            style: context.studioType.label(palette.muted),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.studioNotesSample,
            style: context.studioType.body(palette.ink),
          ),
        ],
      ),
    );
  }
}
