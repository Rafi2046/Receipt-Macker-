import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';

/// A slider drawn over a color gradient track (hue, shade), with a round
/// thumb filled with the current [thumbColor].
class GradientSlider extends StatelessWidget {
  const GradientSlider({
    required this.colors,
    required this.value,
    required this.onChanged,
    required this.thumbColor,
    required this.semanticLabel,
    this.min = 0,
    this.max = 1,
    super.key,
  });

  final List<Color> colors;
  final double value;
  final double min;
  final double max;
  final Color thumbColor;
  final String semanticLabel;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.appColors;
    return SizedBox(
      height: AppSizes.minTapTarget,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.minTapTarget / 2,
            ),
            child: Container(
              height: AppSizes.colorTrackHeight,
              decoration: BoxDecoration(
                borderRadius: AppRadius.chip,
                gradient: LinearGradient(colors: colors),
                border: Border.all(color: theme.border),
              ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: AppSizes.colorTrackHeight,
              activeTrackColor: theme.surface.withValues(alpha: 0),
              inactiveTrackColor: theme.surface.withValues(alpha: 0),
              overlayColor: thumbColor.withValues(alpha: 0.16),
              thumbColor: thumbColor,
              thumbShape: _RingThumb(ring: theme.surface, edge: theme.border),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              semanticFormatterCallback: (_) => semanticLabel,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Thumb with a white ring so it shows on any part of the gradient.
class _RingThumb extends SliderComponentShape {
  const _RingThumb({required this.ring, required this.edge});

  final Color ring;
  final Color edge;

  static const double _radius = 13;
  static const double _ringWidth = 3;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size.fromRadius(_radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    canvas
      ..drawCircle(center, _radius + 0.5, Paint()..color = edge)
      ..drawCircle(center, _radius, Paint()..color = ring)
      ..drawCircle(
        center,
        _radius - _ringWidth,
        Paint()..color = sliderTheme.thumbColor ?? ring,
      );
  }
}
