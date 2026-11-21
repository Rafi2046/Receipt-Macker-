import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The empty-state character: a little receipt with a torn bottom edge,
/// a face that blinks, and two lines of "text". [progress] runs 0 → 1 once
/// per loop.
class EmptyBuddyPainter extends CustomPainter {
  const EmptyBuddyPainter({
    required this.progress,
    required this.paper,
    required this.edge,
    required this.ink,
    required this.blush,
    required this.shadow,
  });

  final double progress;
  final Color paper;
  final Color edge;
  final Color ink;
  final Color blush;
  final Color shadow;

  static const double _corner = 12;
  static const int _teeth = 5;
  static const double _toothDepth = 5;
  static const double _edgeStroke = 1.2;
  static const double _eyeRadius = 3.2;
  static const double _mouthStroke = 1.8;
  static const double _cheekRadius = 4;
  static const double _lineHeight = 4;

  /// The eyes close briefly once per loop.
  static const double _blinkStart = 0.46;
  static const double _blinkEnd = 0.54;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final body = _body(w, h);
    canvas
      ..drawShadow(body, shadow, 6, false)
      ..drawPath(body, Paint()..color = paper)
      ..drawPath(
        body,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = _edgeStroke
          ..color = edge,
      );
    final inkPaint = Paint()..color = ink;
    final open = progress > _blinkStart && progress < _blinkEnd ? 0.15 : 1.0;
    for (final x in [0.33, 0.67]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(w * x, h * 0.32),
          width: _eyeRadius * 2,
          height: _eyeRadius * 2 * open,
        ),
        inkPaint,
      );
    }
    final cheek = Paint()..color = blush;
    canvas
      ..drawCircle(Offset(w * 0.2, h * 0.43), _cheekRadius, cheek)
      ..drawCircle(Offset(w * 0.8, h * 0.43), _cheekRadius, cheek)
      ..drawArc(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.39),
          width: w * 0.22,
          height: h * 0.12,
        ),
        math.pi * 0.1,
        math.pi * 0.8,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = _mouthStroke
          ..strokeCap = StrokeCap.round
          ..color = ink,
      );
    final line = Paint()..color = edge;
    for (final (y, width) in [(0.62, 0.6), (0.74, 0.38)]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.2, h * y, w * width, _lineHeight),
          const Radius.circular(_lineHeight / 2),
        ),
        line,
      );
    }
  }

  /// Rounded top, straight sides, zigzag bottom.
  Path _body(double w, double h) {
    final path = Path()
      ..moveTo(0, h - _toothDepth)
      ..lineTo(0, _corner)
      ..quadraticBezierTo(0, 0, _corner, 0)
      ..lineTo(w - _corner, 0)
      ..quadraticBezierTo(w, 0, w, _corner)
      ..lineTo(w, h - _toothDepth);
    final tooth = w / _teeth;
    for (var i = 0; i < _teeth; i++) {
      final right = w - i * tooth;
      path
        ..lineTo(right - tooth / 2, h)
        ..lineTo(right - tooth, h - _toothDepth);
    }
    return path..close();
  }

  @override
  bool shouldRepaint(EmptyBuddyPainter old) =>
      old.progress != progress ||
      old.paper != paper ||
      old.edge != edge ||
      old.ink != ink ||
      old.blush != blush;
}
