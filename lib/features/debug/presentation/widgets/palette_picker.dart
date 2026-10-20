import 'package:flutter/material.dart';

import '../../../../app/theme/app_palette.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../settings/domain/models/app_palette_id.dart';

/// Choice chips for the candidate brand palettes.
class PalettePicker extends StatelessWidget {
  const PalettePicker({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final AppPaletteId selected;
  final ValueChanged<AppPaletteId> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final id in AppPaletteId.values)
          ChoiceChip(
            selected: id == selected,
            onSelected: (_) => onSelected(id),
            avatar: _PaletteDot(palette: AppPalette.of(id), isDark: isDark),
            label: Text(switch (id) {
              AppPaletteId.teal => l10n.paletteTeal,
              AppPaletteId.indigo => l10n.paletteIndigo,
              AppPaletteId.green => l10n.paletteGreen,
            }),
          ),
      ],
    );
  }
}

class _PaletteDot extends StatelessWidget {
  const _PaletteDot({required this.palette, required this.isDark});

  final AppPalette palette;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.paletteDot,
      height: AppSizes.paletteDot,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? palette.darkPrimary : palette.lightPrimary,
      ),
    );
  }
}
