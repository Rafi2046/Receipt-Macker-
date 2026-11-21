import 'art_shape.dart';
import 'art_tones.dart';
import 'canvas_design.dart';

/// Writes a design's art as an SVG `data:` URI for a CSS background.
abstract final class ArtSvg {
  /// [firstPage] false leaves out the first-page-only shapes.
  static String dataUri(
    CanvasDesign design,
    ArtTones tones, {
    required bool firstPage,
  }) {
    final w = ArtShape.width.toInt();
    final h = ArtShape.height.toInt();
    final body = StringBuffer(
      '<rect width="$w" height="$h" fill="${tones.hex(design.base)}"/>',
    );
    for (final s in design.shapes) {
      if (s.firstPageOnly && !firstPage) continue;
      body.write(_shape(s, tones));
    }
    final svg =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 $w $h" '
        'preserveAspectRatio="xMidYMid slice">$body</svg>';
    return 'data:image/svg+xml,${Uri.encodeComponent(svg)}';
  }

  static String _shape(ArtShape s, ArtTones tones) {
    final color = tones.hex(s.tone);
    final paint = s.stroke > 0
        ? 'fill="none" stroke="$color" stroke-width="${s.stroke}"'
        : 'fill="$color"';
    final alpha = s.opacity < 1 ? ' opacity="${s.opacity}"' : '';
    final d = s.d;
    return d == null
        ? '<circle cx="${s.cx}" cy="${s.cy}" r="${s.r}" $paint$alpha/>'
        : '<path d="$d" $paint$alpha/>';
  }
}
