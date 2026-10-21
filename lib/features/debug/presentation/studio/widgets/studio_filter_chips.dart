import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../studio_scope.dart';

/// Horizontal status filters with a count on each chip.
class StudioFilterChips extends StatelessWidget {
  const StudioFilterChips({
    required this.labels,
    required this.counts,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<String> labels;
  final List<String> counts;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.buttonHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) => _Chip(
          label: '${labels[index]} ${counts[index]}',
          selected: index == selected,
          onTap: () => onSelected(index),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
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
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Center(
            child: Text(label, style: context.studioType.label(foreground)),
          ),
        ),
      ),
    );
  }
}
