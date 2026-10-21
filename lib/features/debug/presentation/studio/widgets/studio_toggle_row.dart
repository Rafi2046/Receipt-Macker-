import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../studio_scope.dart';
import 'studio_card.dart';

/// A label and a switch. Tapping the row toggles it.
class StudioToggleRow extends StatelessWidget {
  const StudioToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return StudioCard(
      onTap: () => onChanged(!value),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: context.studioType.body(palette.ink)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            thumbColor: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return selected ? palette.onAccent : palette.surface;
            }),
            trackColor: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return selected ? palette.accent : palette.line;
            }),
          ),
        ],
      ),
    );
  }
}
