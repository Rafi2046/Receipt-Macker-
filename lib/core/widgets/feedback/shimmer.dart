import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../services/ads/running_under_test.dart';

/// Sweeps a soft highlight across its [child]'s bones while content loads.
///
/// The child paints plain shapes ([SkeletonBox]); this widget recolors them
/// with a moving gradient. It stands still when the phone asks for reduced
/// motion, and in widget tests (an endless animation never settles).
class Shimmer extends StatefulWidget {
  const Shimmer({required this.child, this.animate, super.key});

  final Widget child;

  /// Forces the sweep on or off; by default it follows the rules above.
  final bool? animate;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  static const Duration _sweep = Duration(milliseconds: 1400);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _sweep,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final wanted =
        widget.animate ??
        (!runningUnderTest && !MediaQuery.disableAnimationsOf(context));
    if (wanted && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!wanted && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final base = colors.surfaceAlt;
    final glow = Color.lerp(colors.surfaceAlt, colors.surface, 0.85) ?? base;
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          colors: [base, glow, base],
          stops: const [0.35, 0.5, 0.65],
          transform: _Slide(_controller.value),
        ).createShader(bounds),
        child: child,
      ),
    );
  }
}

/// Moves the gradient from fully left of the bounds to fully right.
class _Slide extends GradientTransform {
  const _Slide(this.progress);

  final double progress;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * (progress * 2 - 1), 0, 0);
}
