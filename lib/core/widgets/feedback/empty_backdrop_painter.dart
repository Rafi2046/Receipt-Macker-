import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Behind the empty-state character: a soft disc, rings rippling out of
/// it, a ground shadow that breathes with the float, and twinkling stars.
/// [progress] runs 0 → 1 once per loop.
class EmptyBackdropPainter extends CustomPainter {
  const EmptyBackdropPainter({
    required this.progress,
    required this.tint,
    required this.sparkle,
    required this.shadow,
  });

  final double progress;
  final Color tint;
  final Color sparkle;
  final Color shadow;

  static const double _discRadius = 0.34;
  static const double _discAlpha = 0.10;
  static const int _rings = 2;
  static const double _ringStroke = 1.5;
  static const double _ringAlpha = 0.28;
  static const double _shadowY = 0.9;
  static const double _shadowWidth = 0.36;
  static const double _shadowHeight = 0.05;
  static const double _shadowAlpha = 0.10;

  /// Each star: x and y as a share of the box, then its size.
  static const List<(double, double, double)> _stars = [
    (0.14, 0.28, 7),
    (0.88, 0.20, 9),
    (0.84, 0.70, 6),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide;
    final center = Offset(size.width / 2, size.height * 0.46);
    final inner = side * _discRadius;
    canvas.drawCircle(
      center,
      inner,
      Paint()..color = tint.withValues(alpha: _discAlpha),
    );
    for (var i = 0; i < _rings; i++) {
      final p = (progress + i / _rings) % 1;
      canvas.drawCircle(
        center,
        inner + (side / 2 - inner) * p,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = _ringStroke
          ..color = tint.withValues(alpha: _ringAlpha * (1 - p)),
      );
    }
    // The shadow shrinks as the character rises.
    final lift = math.sin(progress * 2 * math.pi);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * _shadowY),
        width: side * _shadowWidth * (1 - 0.14 * lift),
        height: side * _shadowHeight,
      ),
      Paint()..color = shadow.withValues(alpha: _shadowAlpha),
    );
    for (final (i, (x, y, r)) in _stars.indexed) {
      final glow =
          0.5 + 0.5 * math.sin((progress + i / _stars.length) * 2 * math.pi);
      _star(
        canvas,
        Offset(size.width * x, size.height * y),
        r * (0.6 + 0.4 * glow),
        Paint()..color = sparkle.withValues(alpha: 0.35 + 0.65 * glow),
      );
    }
  }

  /// A four-point star with pinched sides.
  void _star(Canvas canvas, Offset c, double r, Paint paint) {
    final path = Path()..moveTo(c.dx, c.dy - r);
    for (var i = 1; i <= 4; i++) {
      final a = -math.pi / 2 + i * math.pi / 2;
      path.quadraticBezierTo(
        c.dx,
        c.dy,
        c.dx + r * math.cos(a),
        c.dy + r * math.sin(a),
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(EmptyBackdropPainter old) =>
      old.progress != progress ||
      old.tint != tint ||
      old.sparkle != sparkle ||
      old.shadow != shadow;
}
