import 'dart:math' as math;

import 'art_shape.dart';

/// Builders for repeating art (hexagons, dot grids, line meshes), so the
/// designs stay short and the shapes stay exact.
abstract final class ArtPatterns {
  static String _n(double v) => v.toStringAsFixed(1);

  /// A flat-topped hexagon outline path.
  static String hexagon(double cx, double cy, double r) {
    final points = [
      for (var i = 0; i < 6; i++)
        '${_n(cx + r * math.cos(math.pi / 3 * i))} '
            '${_n(cy + r * math.sin(math.pi / 3 * i))}',
    ];
    return 'M${points.first} ${points.skip(1).map((p) => 'L$p').join(' ')} Z';
  }

  /// A honeycomb of hexagon outlines whose cells fade with distance from
  /// ([cx], [cy]).
  static List<ArtShape> honeycomb({
    required double cx,
    required double cy,
    required double radius,
    required ArtTone tone,
    double cell = 46,
    bool firstPageOnly = false,
  }) {
    final shapes = <ArtShape>[];
    final dx = cell * 1.5;
    final dy = cell * math.sqrt(3);
    for (var col = -8; col <= 8; col++) {
      for (var row = -8; row <= 8; row++) {
        final x = cx + col * dx;
        final y = cy + row * dy + (col.isOdd ? dy / 2 : 0);
        final dist = math.sqrt(math.pow(x - cx, 2) + math.pow(y - cy, 2));
        if (dist > radius) continue;
        shapes.add(
          ArtShape.path(
            hexagon(x, y, cell * 0.92),
            tone: tone,
            stroke: 2.2,
            opacity: 0.32 * (1 - dist / radius) + 0.06,
            firstPageOnly: firstPageOnly,
          ),
        );
      }
    }
    return shapes;
  }

  /// A corner of dots shrinking away from ([cx], [cy]).
  static List<ArtShape> halftone({
    required double cx,
    required double cy,
    required double radius,
    required ArtTone tone,
    double step = 34,
    double opacity = 0.55,
    bool firstPageOnly = false,
  }) {
    final shapes = <ArtShape>[];
    for (var x = cx - radius; x <= cx + radius; x += step) {
      for (var y = cy - radius; y <= cy + radius; y += step) {
        final dist = math.sqrt(math.pow(x - cx, 2) + math.pow(y - cy, 2));
        final r = step * 0.42 * (1 - dist / radius);
        if (r < 1.5) continue;
        shapes.add(
          ArtShape.circle(
            x,
            y,
            r,
            tone: tone,
            opacity: opacity,
            firstPageOnly: firstPageOnly,
          ),
        );
      }
    }
    return shapes;
  }

  /// A low-poly network: points scattered in the box, each joined to its
  /// nearest neighbors, with small dots on the joints. Always the same
  /// points for the same [seed].
  static List<ArtShape> mesh({
    required double left,
    required double top,
    required double right,
    required double bottom,
    required ArtTone tone,
    int count = 22,
    int seed = 7,
    bool firstPageOnly = false,
  }) {
    final random = math.Random(seed);
    final points = [
      for (var i = 0; i < count; i++)
        (
          left + random.nextDouble() * (right - left),
          top + random.nextDouble() * (bottom - top),
        ),
    ];
    final lines = StringBuffer();
    for (final (i, p) in points.indexed) {
      final near = [...points]
        ..sort((a, b) => _dist(p, a).compareTo(_dist(p, b)));
      for (final q in near.skip(1).take(3)) {
        if (points.indexOf(q) < i) continue;
        lines.write('M${_n(p.$1)} ${_n(p.$2)} L${_n(q.$1)} ${_n(q.$2)} ');
      }
    }
    return [
      ArtShape.path(
        lines.toString().trim(),
        tone: tone,
        stroke: 1.6,
        opacity: 0.35,
        firstPageOnly: firstPageOnly,
      ),
      for (final p in points)
        ArtShape.circle(
          p.$1,
          p.$2,
          4,
          tone: tone,
          opacity: 0.55,
          firstPageOnly: firstPageOnly,
        ),
    ];
  }

  /// A field of small squares, brightest near the right edge and fading
  /// out to the left. Always the same tiles for the same [seed].
  static List<ArtShape> tiles({
    required double left,
    required double top,
    required double right,
    required double bottom,
    required ArtTone tone,
    double cell = 40,
    double gap = 5,
    int seed = 5,
    double strength = 1,
    bool firstPageOnly = false,
  }) {
    final random = math.Random(seed);
    final shapes = <ArtShape>[];
    for (var x = left; x < right; x += cell) {
      for (var y = top; y < bottom; y += cell) {
        final fade = (x - left) / (right - left);
        final opacity = strength * fade * (0.12 + random.nextDouble() * 0.5);
        if (opacity < 0.04) continue;
        final x2 = x + cell - gap;
        final y2 = y + cell - gap;
        shapes.add(
          ArtShape.path(
            'M${_n(x)} ${_n(y)} L${_n(x2)} ${_n(y)} L${_n(x2)} ${_n(y2)} '
            'L${_n(x)} ${_n(y2)} Z',
            tone: tone,
            opacity: double.parse(opacity.toStringAsFixed(2)),
            firstPageOnly: firstPageOnly,
          ),
        );
      }
    }
    return shapes;
  }

  static double _dist((double, double) a, (double, double) b) =>
      math.pow(a.$1 - b.$1, 2) + math.pow(a.$2 - b.$2, 2).toDouble();
}
