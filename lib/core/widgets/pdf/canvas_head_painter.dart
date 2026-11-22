import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import '../../services/pdf/canvas/art_tones.dart';
import '../../services/pdf/canvas/canvas_design.dart';
import 'canvas_art_painter.dart';

/// Paints a brand design's header: its color, the art covering it from
/// the right, and the edge strip stretched along the bottom, as the PDF
/// does.
class CanvasHeadPainter extends CustomPainter {
  CanvasHeadPainter({
    required this.design,
    required this.tones,
    required this.edgeHeight,
  });

  final CanvasDesign design;
  final ArtTones tones;

  /// Height of the edge strip in this box.
  final double edgeHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final box = Offset.zero & size;
    canvas
      ..save()
      ..clipRect(box)
      ..drawRect(
        box,
        Paint()..color = CanvasArtPainter.colorOf(tones.hex(design.headBase)),
      );
    final scale = math.max(
      size.width / CanvasDesign.headWidth,
      size.height / CanvasDesign.headHeight,
    );
    canvas
      ..save()
      ..translate(
        size.width - CanvasDesign.headWidth * scale,
        (size.height - CanvasDesign.headHeight * scale) / 2,
      )
      ..scale(scale);
    CanvasArtPainter.paintShapes(canvas, design.headShapes, tones);
    canvas.restore();
    if (edgeHeight > 0) {
      canvas
        ..translate(0, size.height - edgeHeight)
        ..scale(
          size.width / CanvasDesign.edgeWidth,
          edgeHeight / CanvasDesign.edgeHeight,
        );
      CanvasArtPainter.paintShapes(canvas, design.edgeShapes, tones);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CanvasHeadPainter oldDelegate) =>
      oldDelegate.design != design ||
      oldDelegate.tones.accent != tones.accent ||
      oldDelegate.edgeHeight != edgeHeight;
}
