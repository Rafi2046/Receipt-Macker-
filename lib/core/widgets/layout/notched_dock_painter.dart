import 'package:flutter/material.dart';

/// Paints the dock: a pill with a smooth notch cut into the top centre,
/// where the create button floats.
class NotchedDockPainter extends CustomPainter {
  const NotchedDockPainter({
    required this.color,
    required this.borderColor,
    required this.shadowColor,
    required this.notchRadius,
  });

  final Color color;
  final Color borderColor;
  final Color shadowColor;

  /// Half the notch width at the top edge.
  final double notchRadius;

  static const double _shoulder = 14;

  Path _path(Size size) {
    final w = size.width;
    final h = size.height;
    final r = h / 2;
    final cx = w / 2;
    final n = notchRadius;
    final depth = n * 0.95;
    return Path()
      ..moveTo(r, 0)
      ..lineTo(cx - n - _shoulder, 0)
      ..cubicTo(cx - n + 2, 0, cx - n * 0.85, depth, cx, depth)
      ..cubicTo(cx + n * 0.85, depth, cx + n - 2, 0, cx + n + _shoulder, 0)
      ..lineTo(w - r, 0)
      ..arcToPoint(Offset(w - r, h), radius: Radius.circular(r))
      ..lineTo(r, h)
      ..arcToPoint(Offset(r, 0), radius: Radius.circular(r))
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _path(size);
    canvas
      ..drawShadow(path, shadowColor, 10, false)
      ..drawPath(path, Paint()..color = color)
      ..drawPath(
        path,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
  }

  @override
  bool shouldRepaint(NotchedDockPainter old) =>
      old.color != color ||
      old.borderColor != borderColor ||
      old.shadowColor != shadowColor ||
      old.notchRadius != notchRadius;
}
