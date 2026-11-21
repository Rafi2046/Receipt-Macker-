import 'art_patterns.dart';
import 'art_shape.dart';
import 'canvas_design.dart';

/// Canvas designs on a light page with dark text.
abstract final class CanvasArtsLight {
  /// Watercolor ribbons flowing down the left edge.
  static const CanvasDesign wave = CanvasDesign(
    skeleton: CanvasSkeleton.sheet,
    shapes: [
      ArtShape.path(
        'M0 0 L280 0 C150 260 330 560 170 860 C60 1080 240 1270 150 1414 '
        'L0 1414 Z',
        tone: ArtTone.accent,
        opacity: 0.16,
      ),
      ArtShape.path(
        'M0 0 L170 0 C320 300 70 580 230 870 C330 1090 80 1260 90 1414 '
        'L0 1414 Z',
        tone: ArtTone.pair,
        opacity: 0.22,
      ),
      ArtShape.path(
        'M0 0 L70 0 C220 420 10 720 110 1010 C170 1210 30 1350 50 1414 '
        'L0 1414 Z',
        tone: ArtTone.deep,
        opacity: 0.12,
      ),
      ArtShape.path(
        'M1000 1414 L1000 1120 C900 1210 830 1320 690 1414 Z',
        tone: ArtTone.accent,
        opacity: 0.10,
      ),
    ],
  );

  /// Low-poly network lines in two corners.
  static final CanvasDesign mesh = CanvasDesign(
    skeleton: CanvasSkeleton.sheet,
    marginTopMm: 30,
    shapes: [
      ...ArtPatterns.mesh(
        left: 360,
        top: -40,
        right: 1060,
        bottom: 125,
        tone: ArtTone.accent,
      ),
      ...ArtPatterns.mesh(
        left: -40,
        top: 1345,
        right: 640,
        bottom: 1460,
        tone: ArtTone.deep,
        seed: 11,
      ),
      const ArtShape.path(
        'M1000 0 L1000 160 L840 0 Z',
        tone: ArtTone.accent,
        opacity: 0.85,
      ),
    ],
  );

  /// Folded triangles in the top-right and bottom-left corners.
  static const CanvasDesign corner = CanvasDesign(
    skeleton: CanvasSkeleton.sheet,
    marginTopMm: 22,
    marginSideMm: 18,
    shapes: [
      ArtShape.path('M1000 0 L1000 240 L760 0 Z', tone: ArtTone.accent),
      ArtShape.path('M1000 0 L1000 140 L860 0 Z', tone: ArtTone.deep),
      ArtShape.path('M760 0 L790 0 L1000 210 L1000 240 Z', tone: ArtTone.pair),
      ArtShape.path('M0 1414 L0 1174 L240 1414 Z', tone: ArtTone.accent),
      ArtShape.path('M0 1414 L0 1274 L140 1414 Z', tone: ArtTone.deep),
      ArtShape.path(
        'M0 1174 L0 1204 L210 1414 L240 1414 Z',
        tone: ArtTone.pair,
      ),
    ],
  );

  /// Soft overlapping bubbles at the edges.
  static const CanvasDesign bubble = CanvasDesign(
    skeleton: CanvasSkeleton.sheet,
    shapes: [
      ArtShape.circle(1040, -30, 290, tone: ArtTone.accent, opacity: 0.12),
      ArtShape.circle(880, -30, 95, tone: ArtTone.pair, opacity: 0.25),
      ArtShape.circle(
        1010,
        250,
        70,
        tone: ArtTone.deep,
        opacity: 0.5,
        stroke: 5,
      ),
      ArtShape.circle(-70, 1470, 340, tone: ArtTone.accent, opacity: 0.12),
      ArtShape.circle(230, 1340, 80, tone: ArtTone.pair, opacity: 0.32),
      ArtShape.circle(
        960,
        1330,
        130,
        tone: ArtTone.accent,
        opacity: 0.35,
        stroke: 6,
      ),
    ],
  );

  /// Honeycomb outlines fading out of two corners.
  static final CanvasDesign hive = CanvasDesign(
    skeleton: CanvasSkeleton.sheet,
    marginTopMm: 24,
    shapes: [
      ...ArtPatterns.honeycomb(
        cx: 1000,
        cy: -60,
        radius: 300,
        tone: ArtTone.accent,
      ),
      ...ArtPatterns.honeycomb(
        cx: 0,
        cy: 1414,
        radius: 340,
        tone: ArtTone.deep,
      ),
      ArtShape.path(
        ArtPatterns.hexagon(972, 28, 30),
        tone: ArtTone.pair,
        opacity: 0.9,
      ),
      ArtShape.path(
        ArtPatterns.hexagon(70, 1340, 42),
        tone: ArtTone.accent,
        opacity: 0.85,
      ),
    ],
  );

  /// Color waves running down the right edge of every page.
  static const CanvasDesign tide = CanvasDesign(
    skeleton: CanvasSkeleton.sheet,
    marginSideMm: 20,
    shapes: [
      ArtShape.path(
        'M1000 0 L945 0 C905 200 985 400 940 600 C895 800 980 1000 935 1200 '
        'C912 1320 952 1380 948 1414 L1000 1414 Z',
        tone: ArtTone.accent,
      ),
      ArtShape.path(
        'M1000 0 L970 0 C940 220 1000 420 965 620 C930 820 998 1020 962 1220 '
        'C944 1330 972 1390 970 1414 L1000 1414 Z',
        tone: ArtTone.pair,
        opacity: 0.9,
      ),
      ArtShape.path(
        'M1000 0 L990 0 C975 300 1000 600 985 900 C975 1100 995 1300 990 '
        '1414 L1000 1414 Z',
        tone: ArtTone.deep,
      ),
    ],
  );

  /// Dots shrinking out of the top-right and bottom-left corners.
  static final CanvasDesign halftone = CanvasDesign(
    skeleton: CanvasSkeleton.sheet,
    marginTopMm: 24,
    shapes: [
      ...ArtPatterns.halftone(
        cx: 1000,
        cy: -40,
        radius: 250,
        tone: ArtTone.accent,
      ),
      ...ArtPatterns.halftone(
        cx: 0,
        cy: 1414,
        radius: 300,
        tone: ArtTone.pair,
        opacity: 0.7,
      ),
    ],
  );

  /// A fine double frame with square corner studs on every page.
  static const CanvasDesign frame = CanvasDesign(
    skeleton: CanvasSkeleton.sheet,
    marginTopMm: 20,
    marginSideMm: 20,
    marginBottomMm: 26,
    shapes: [
      ArtShape.path(
        'M24 24 L976 24 L976 1390 L24 1390 Z',
        tone: ArtTone.accent,
        stroke: 5,
      ),
      ArtShape.path(
        'M36 36 L964 36 L964 1378 L36 1378 Z',
        tone: ArtTone.pair,
        stroke: 1.6,
      ),
      ArtShape.path('M8 8 L44 8 L44 44 L8 44 Z', tone: ArtTone.accent),
      ArtShape.path('M956 8 L992 8 L992 44 L956 44 Z', tone: ArtTone.accent),
      ArtShape.path(
        'M8 1370 L44 1370 L44 1406 L8 1406 Z',
        tone: ArtTone.accent,
      ),
      ArtShape.path(
        'M956 1370 L992 1370 L992 1406 L956 1406 Z',
        tone: ArtTone.accent,
      ),
    ],
  );

  /// Diagonal pinstripes across two corners.
  static final CanvasDesign lattice = CanvasDesign(
    skeleton: CanvasSkeleton.sheet,
    marginTopMm: 24,
    shapes: [
      ArtShape.path(
        [for (var i = 0; i < 7; i++) 'M${i * 26} 0 L0 ${i * 26}'].join(' '),
        tone: ArtTone.accent,
        stroke: 3,
        opacity: 0.55,
      ),
      ArtShape.path(
        [
          for (var i = 0; i < 16; i++)
            'M1000 ${1414 - i * 26} L${1000 - i * 26} 1414',
        ].join(' '),
        tone: ArtTone.deep,
        stroke: 3,
        opacity: 0.3,
      ),
      const ArtShape.path(
        'M1000 1414 L1000 1270 L856 1414 Z',
        tone: ArtTone.pair,
      ),
      const ArtShape.path('M0 0 L110 0 L0 110 Z', tone: ArtTone.accent),
    ],
  );
}
