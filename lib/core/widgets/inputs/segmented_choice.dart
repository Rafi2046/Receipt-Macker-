import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_durations.dart';
import '../../constants/app_opacity.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// Single choice between a few short options, drawn as one track with a
/// raised pill on the selected option. [options] pairs each value with its
/// label.
class SegmentedChoice<T> extends StatelessWidget {
  const SegmentedChoice({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final List<(T, String)> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: AppRadius.card,
      ),
      child: Row(
        children: [
          for (final (option, label) in options)
            Expanded(
              child: _Segment(
                label: label,
                selected: option == value,
                onTap: () => onChanged(option),
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        // The padding is part of the tap area, so each option is a full
        // tap target while the pill itself stays slim.
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: AnimatedContainer(
            duration: AppDurations.fast,
            constraints: const BoxConstraints(minHeight: _pillHeight),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: selected ? 1 : 0),
              borderRadius: AppRadius.input,
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: colors.textPrimary.withValues(
                      alpha: AppOpacity.shadow,
                    ),
                    blurRadius: AppSpacing.sm,
                    offset: const Offset(0, AppSpacing.xxs),
                  ),
              ],
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.labelLarge?.copyWith(
                color: selected ? colors.primary : colors.textSecondary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// With the padding around it this makes a 48dp tap target.
  static const double _pillHeight = AppSizes.minTapTarget - 2 * AppSpacing.xs;
}
