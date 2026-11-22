import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_spacing.dart';
import '../../utils/extensions/l10n_extension.dart';

/// Opens the unit list. Returns the chosen unit ('' for none), or null
/// when dismissed. "Create unit" asks for a name of up to [maxLength].
Future<String?> showUnitPicker(
  BuildContext context, {
  required String current,
  required int maxLength,
}) async {
  final l10n = context.l10n;
  final units = <String>{
    l10n.unitPcs,
    l10n.unitHour,
    l10n.unitDay,
    l10n.unitMonth,
    l10n.unitKg,
    l10n.unitLitre,
    l10n.unitBox,
    if (current.isNotEmpty) current,
  };
  final picked = await showModalBottomSheet<_UnitPick>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => _UnitSheet(units: units.toList(), current: current),
  );
  if (picked == null || !context.mounted) return null;
  if (!picked.create) return picked.unit;
  final name = await showDialog<String>(
    context: context,
    builder: (_) => _CreateUnitDialog(maxLength: maxLength),
  );
  final trimmed = name?.trim() ?? '';
  return trimmed.isEmpty ? null : trimmed;
}

typedef _UnitPick = ({String unit, bool create});

class _UnitSheet extends StatelessWidget {
  const _UnitSheet({required this.units, required this.current});

  final List<String> units;
  final String current;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    void pick(String unit) =>
        Navigator.of(context).pop((unit: unit, create: false));
    Widget row(String label, String unit) => ListTile(
      title: Text(label),
      trailing: unit == current
          ? Icon(AppIcons.check, color: colors.primary)
          : null,
      onTap: () => pick(unit),
    );
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            0,
            AppSpacing.pagePadding,
            AppSpacing.sm,
          ),
          child: Text(l10n.unitOfMeasure, style: context.textStyles.titleLarge),
        ),
        row(l10n.unitNone, ''),
        for (final unit in units) row(unit, unit),
        ListTile(
          leading: Icon(AppIcons.add, color: colors.primary),
          title: Text(l10n.unitCreate, style: TextStyle(color: colors.primary)),
          onTap: () => Navigator.of(context).pop((unit: '', create: true)),
        ),
      ],
    );
  }
}

class _CreateUnitDialog extends StatefulWidget {
  const _CreateUnitDialog({required this.maxLength});

  final int maxLength;

  @override
  State<_CreateUnitDialog> createState() => _CreateUnitDialogState();
}

class _CreateUnitDialogState extends State<_CreateUnitDialog> {
  final TextEditingController _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _done() => Navigator.of(context).pop(_name.text);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.unitCreate),
      content: TextField(
        controller: _name,
        autofocus: true,
        maxLength: widget.maxLength,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(hintText: l10n.unitNameHint),
        onSubmitted: (_) => _done(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        TextButton(onPressed: _done, child: Text(l10n.ok)),
      ],
    );
  }
}
