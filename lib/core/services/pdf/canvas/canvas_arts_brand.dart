import 'art_patterns.dart';
import 'art_shape.dart';
import 'canvas_design.dart';

/// Canvas designs with the logo on a full-width color header.
abstract final class CanvasArtsBrand {
  /// Layered ribbons flowing along the header's lower edge.
  static const CanvasDesign swoosh = CanvasDesign(
    skeleton: CanvasSkeleton.brand,
    marginBottomMm: 18,
    edgeMm: 17,
    headShapes: [
      ArtShape.path(
        'M0 0 L460 0 C340 130 170 210 0 230 Z',
        tone: ArtTone.deep,
        opacity: 0.35,
      ),
      ArtShape.path(
        'M1000 0 L1000 280 L640 280 C820 230 940 130 1000 0 Z',
        tone: ArtTone.paper,
        opacity: 0.08,
      ),
    ],
    edgeShapes: [
      ArtShape.path(
        'M0 100 L0 8 C260 120 560 -40 1000 36 L1000 100 Z',
        tone: ArtTone.paper,
        opacity: 0.28,
      ),
      ArtShape.path(
        'M0 100 L0 42 C240 132 600 -4 1000 54 L1000 100 Z',
        tone: ArtTone.paper,
        opacity: 0.4,
      ),
      ArtShape.path(
        'M0 100 L0 70 C260 138 620 22 1000 76 L1000 100 Z',
        tone: ArtTone.paper,
      ),
    ],
    shapes: [
      ArtShape.path(
        'M0 1414 L0 1352 C150 1392 290 1400 420 1400 L1000 1400 L1000 1414 Z',
        tone: ArtTone.accent,
      ),
      ArtShape.path(
        'M1000 1414 L1000 1340 C880 1392 760 1404 620 1404 L0 1404 L0 1414 Z',
        tone: ArtTone.deep,
        opacity: 0.55,
      ),
    ],
  );

  /// Slanted stripes through the header and ticks along the foot.
  static const CanvasDesign slant = CanvasDesign(
    skeleton: CanvasSkeleton.brand,
    edgeMm: 3.5,
    headShapes: [
      ArtShape.path(
        'M520 280 L660 0 L720 0 L580 280 Z',
        tone: ArtTone.paper,
        opacity: 0.16,
      ),
      ArtShape.path(
        'M610 280 L750 0 L1000 0 L1000 280 Z',
        tone: ArtTone.deep,
        opacity: 0.42,
      ),
      ArtShape.path(
        'M0 280 L0 170 L55 280 Z',
        tone: ArtTone.deep,
        opacity: 0.42,
      ),
    ],
    edgeShapes: [
      ArtShape.path('M0 0 L1000 0 L1000 100 L0 100 Z', tone: ArtTone.pair),
      ArtShape.path('M0 0 L330 0 L300 100 L0 100 Z', tone: ArtTone.deep),
    ],
    shapes: [
      ArtShape.path(
        'M0 1397 L1000 1397 L1000 1414 L0 1414 Z',
        tone: ArtTone.accent,
      ),
      ArtShape.path(
        'M110 1397 L165 1397 L148 1414 L93 1414 Z',
        tone: ArtTone.paper,
      ),
      ArtShape.path(
        'M185 1397 L212 1397 L195 1414 L168 1414 Z',
        tone: ArtTone.pair,
      ),
    ],
  );

  /// Big rings and discs in the header's right corner.
  static const CanvasDesign capsule = CanvasDesign(
    skeleton: CanvasSkeleton.brand,
    edgeMm: 2.5,
    headShapes: [
      ArtShape.circle(900, 40, 240, tone: ArtTone.deep, opacity: 0.45),
      ArtShape.circle(
        900,
        40,
        310,
        tone: ArtTone.paper,
        opacity: 0.22,
        stroke: 3,
      ),
      ArtShape.circle(640, 262, 70, tone: ArtTone.paper, opacity: 0.1),
      ArtShape.circle(585, 44, 11, tone: ArtTone.pair),
      ArtShape.circle(20, 280, 90, tone: ArtTone.deep, opacity: 0.3),
    ],
    edgeShapes: [
      ArtShape.path('M0 0 L1000 0 L1000 100 L0 100 Z', tone: ArtTone.pair),
    ],
    shapes: [
      ArtShape.circle(40, 1414, 95, tone: ArtTone.accent),
      ArtShape.circle(
        40,
        1414,
        135,
        tone: ArtTone.accent,
        opacity: 0.4,
        stroke: 3,
      ),
      ArtShape.circle(962, 1392, 40, tone: ArtTone.pair),
      ArtShape.circle(900, 1404, 12, tone: ArtTone.accent, opacity: 0.6),
    ],
  );

  /// A dark header of small glowing tiles.
  static final CanvasDesign pixel = CanvasDesign(
    skeleton: CanvasSkeleton.brand,
    headBase: ArtTone.deep,
    headShapes: ArtPatterns.tiles(
      left: 300,
      top: 0,
      right: 1000,
      bottom: 280,
      tone: ArtTone.paper,
      strength: 0.42,
    ),
    shapes: [
      const ArtShape.path(
        'M0 1400 L1000 1400 L1000 1414 L0 1414 Z',
        tone: ArtTone.deep,
      ),
      ...ArtPatterns.tiles(
        left: 800,
        top: 1360,
        right: 1000,
        bottom: 1400,
        tone: ArtTone.accent,
        seed: 9,
      ),
    ],
  );

  /// A black header with bands of grey silk.
  static const CanvasDesign silk = CanvasDesign(
    skeleton: CanvasSkeleton.brand,
    headBase: ArtTone.ink,
    edgeMm: 15,
    headShapes: [
      ArtShape.path(
        'M360 0 C560 130 760 40 1000 160 L1000 70 C800 -20 620 60 470 0 Z',
        tone: ArtTone.mist,
        opacity: 0.22,
      ),
      ArtShape.path(
        'M280 280 C520 150 760 260 1000 180 L1000 240 C800 300 560 220 '
        '410 280 Z',
        tone: ArtTone.mist,
        opacity: 0.15,
      ),
      ArtShape.path(
        'M620 0 C760 90 880 60 1000 100 L1000 0 Z',
        tone: ArtTone.accent,
        opacity: 0.55,
      ),
    ],
    edgeShapes: [
      ArtShape.path(
        'M0 100 L0 24 C250 112 600 -24 1000 46 L1000 100 Z',
        tone: ArtTone.mist,
        opacity: 0.45,
      ),
      ArtShape.path(
        'M0 100 L0 50 C270 120 620 4 1000 62 L1000 100 Z',
        tone: ArtTone.accent,
      ),
      ArtShape.path(
        'M0 100 L0 62 C280 128 640 16 1000 74 L1000 100 Z',
        tone: ArtTone.paper,
      ),
    ],
    shapes: [
      ArtShape.path(
        'M0 1399 L1000 1399 L1000 1414 L0 1414 Z',
        tone: ArtTone.ink,
      ),
      ArtShape.path(
        'M0 1393 L1000 1393 L1000 1399 L0 1399 Z',
        tone: ArtTone.accent,
      ),
    ],
  );

  /// A pale header with playful discs; the title sits on a color blob.
  static const CanvasDesign confetti = CanvasDesign(
    skeleton: CanvasSkeleton.brand,
    headBase: ArtTone.soft,
    headInk: true,
    headShapes: [
      ArtShape.path(
        'M1000 0 L1000 280 L690 280 C560 210 640 90 585 0 Z',
        tone: ArtTone.accent,
      ),
      ArtShape.circle(560, 262, 50, tone: ArtTone.pair, opacity: 0.9),
      ArtShape.circle(520, 34, 22, tone: ArtTone.accent, opacity: 0.45),
      ArtShape.circle(30, 290, 70, tone: ArtTone.accent, opacity: 0.16),
      ArtShape.circle(960, 250, 90, tone: ArtTone.deep, opacity: 0.3),
      ArtShape.circle(860, 10, 46, tone: ArtTone.paper, opacity: 0.16),
    ],
    shapes: [
      ArtShape.circle(0, 1414, 84, tone: ArtTone.accent, opacity: 0.22),
      ArtShape.circle(956, 1414, 60, tone: ArtTone.pair, opacity: 0.9),
      ArtShape.circle(884, 1398, 16, tone: ArtTone.accent),
      ArtShape.circle(
        120,
        1396,
        20,
        tone: ArtTone.accent,
        opacity: 0.35,
        stroke: 6,
      ),
    ],
  );
}
