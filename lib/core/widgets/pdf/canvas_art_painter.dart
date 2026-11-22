import 'package:flutter/rendering.dart';

import '../../services/pdf/canvas/art_path.dart';
import '../../services/pdf/canvas/art_shape.dart';
import '../../services/pdf/canvas/art_tones.dart';
import '../../services/pdf/canvas/canvas_design.dart';

/// Paints a canvas design's page art, the same shapes the PDF uses, scaled
/// to cover the box (first-page version).
class CanvasArtPainter extends CustomPainter {
  CanvasArtPainter({required this.design, required this.tones});

  final CanvasDesign design;
  final ArtTones tones;

  /// A `#RRGGBB` (or `#RRGGBBAA`) tone as an opaque color.
  static Color colorOf(String hex) => _color(hex);

  /// Draws [shapes] in canvas units; the caller sets the transform.
  static void paintShapes(
    Canvas canvas,
    Iterable<ArtShape> shapes,
    ArtTones tones,
  ) {
    for (final shape in shapes) {
      _paintShape(canvas, shape, tones);
    }
  }

  static Color _color(String hex) {
    final clean = hex.replaceAll('#', '');
    final rgb = int.tryParse(clean.substring(0, 6), radix: 16) ?? 0;
    return Color(0xFF000000 | rgb);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = _color(tones.hex(design.base)),
    );
    final scale = size.width / ArtShape.width;
    canvas
      ..save()
      ..clipRect(Offset.zero & size)
      ..scale(scale);
    paintShapes(canvas, design.shapes, tones);
    canvas.restore();
  }

  static void _paintShape(Canvas canvas, ArtShape shape, ArtTones tones) {
    final paint = Paint()
      ..color = _color(tones.hex(shape.tone)).withValues(alpha: shape.opacity)
      ..isAntiAlias = true;
    if (shape.stroke > 0) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = shape.stroke;
    }
    final d = shape.d;
    if (d == null) {
      canvas.drawCircle(Offset(shape.cx, shape.cy), shape.r, paint);
      return;
    }
    canvas.drawPath(_path(d), paint);
  }

  static Path _path(String d) {
    final path = Path();
    for (final (:command, :values) in ArtPath.parse(d)) {
      switch (command) {
        case 'M' when values.length >= 2:
          path.moveTo(values[0], values[1]);
        case 'L' when values.length >= 2:
          path.lineTo(values[0], values[1]);
        case 'Q' when values.length >= 4:
          path.quadraticBezierTo(values[0], values[1], values[2], values[3]);
        case 'C' when values.length >= 6:
          path.cubicTo(
            values[0],
            values[1],
            values[2],
            values[3],
            values[4],
            values[5],
          );
        case 'Z':
          path.close();
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(CanvasArtPainter oldDelegate) =>
      oldDelegate.design != design || oldDelegate.tones.accent != tones.accent;
}
