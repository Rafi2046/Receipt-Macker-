import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_durations.dart';
import '../../constants/app_opacity.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import 'empty_backdrop_painter.dart';
import 'empty_buddy_painter.dart';

/// Animated picture for an empty list: a little receipt character that
/// floats and blinks, wearing [icon] as a badge so each screen has its own.
/// Stands still when the system asks for reduced motion.
class EmptyIllustration extends StatefulWidget {
  const EmptyIllustration({required this.icon, super.key});

  final IconData icon;

  /// Tests switch the endless loop off so `pumpAndSettle` can finish.
  @visibleForTesting
  static bool loops = true;

  @override
  State<EmptyIllustration> createState() => _EmptyIllustrationState();
}

class _EmptyIllustrationState extends State<EmptyIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: AppDurations.ambientLoop,
  );

  /// The character's box, as a share of the whole picture.
  static const double _buddyWidth = 0.4;
  static const double _buddyHeight = 0.5;

  /// How far the character leans each way, in radians.
  static const double _tilt = 0.04;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final still =
        !EmptyIllustration.loops || MediaQuery.disableAnimationsOf(context);
    if (still) {
      _loop.stop();
    } else if (!_loop.isAnimating) {
      _loop.repeat();
    }
  }

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    const side = AppSizes.emptyIllustration;
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: SizedBox.square(
          dimension: side,
          child: AnimatedBuilder(
            animation: _loop,
            builder: (context, badge) {
              final t = _loop.value;
              final wave = math.sin(t * 2 * math.pi);
              return CustomPaint(
                painter: EmptyBackdropPainter(
                  progress: t,
                  tint: colors.primary,
                  sparkle: colors.warning,
                  shadow: colors.shadow,
                ),
                child: Center(
                  child: Transform.translate(
                    offset: Offset(0, -wave * AppSpacing.xs - AppSpacing.sm),
                    child: Transform.rotate(
                      angle: wave * _tilt,
                      child: SizedBox(
                        width: side * _buddyWidth,
                        height: side * _buddyHeight,
                        child: CustomPaint(
                          painter: EmptyBuddyPainter(
                            progress: t,
                            // Lifted off the dark background; white on light.
                            paper: dark ? colors.surfaceAlt : colors.surface,
                            edge: colors.border,
                            ink: colors.textPrimary,
                            blush: colors.primary.withValues(
                              alpha: AppOpacity.disabled,
                            ),
                            shadow: colors.textPrimary.withValues(
                              alpha: AppOpacity.tint,
                            ),
                          ),
                          child: badge,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            child: _Badge(icon: widget.icon),
          ),
        ),
      ),
    );
  }
}

/// The screen's icon on a filled disc, pinned to the character's corner.
class _Badge extends StatelessWidget {
  const _Badge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Align(
      alignment: const Alignment(1.7, 1.15),
      child: Container(
        width: AppSizes.avatarSm,
        height: AppSizes.avatarSm,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.primary,
          border: Border.all(
            color: colors.surface,
            width: AppSizes.selectedBorderWidth,
          ),
        ),
        child: Icon(icon, size: AppSizes.iconSm, color: colors.onPrimary),
      ),
    );
  }
}
