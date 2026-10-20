import 'package:flutter/material.dart';

/// Launcher mask shapes: Pixel uses a circle, Samsung One UI a squircle.
enum LauncherMask { circle, squircle }

/// An adaptive icon as a launcher draws it: the full 108-unit artwork is
/// cropped to its middle 72 units, then clipped to the mask.
class LauncherIconPreview extends StatelessWidget {
  const LauncherIconPreview({
    required this.asset,
    required this.size,
    this.mask = LauncherMask.squircle,
    super.key,
  });

  final String asset;
  final double size;
  final LauncherMask mask;

  /// 108 / 72: the visible part of an adaptive icon layer.
  static const double _adaptiveZoom = 1.5;

  /// One UI's squircle is close to a continuous rectangle at this radius.
  static const double _squircleRadiusFactor = 0.62;

  @override
  Widget build(BuildContext context) {
    final image = OverflowBox(
      maxWidth: size * _adaptiveZoom,
      maxHeight: size * _adaptiveZoom,
      child: Image.asset(asset),
    );
    final shape = switch (mask) {
      LauncherMask.circle => const CircleBorder(),
      LauncherMask.squircle => ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(size * _squircleRadiusFactor),
      ),
    };
    return SizedBox.square(
      dimension: size,
      child: ClipPath(
        clipper: ShapeBorderClipper(shape: shape),
        child: image,
      ),
    );
  }
}
