import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../studio_scope.dart';

/// Wrapped choices. The selected one uses the brand fill.
class StudioChoiceRow extends StatelessWidget {
  const StudioChoiceRow({
    required this.labels,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (var index = 0; index < labels.length; index++)
          _Choice(
            label: labels[index],
            selected: index == selected,
            onTap: () => onSelected(index),
          ),
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final background = selected ? palette.accent : palette.surface;
    final foreground = selected ? palette.onAccent : palette.ink;
    return Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.chip,
        side: BorderSide(color: selected ? palette.accent : palette.line),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.chip,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: Text(label, style: context.studioType.label(foreground)),
        ),
      ),
    );
  }
}
