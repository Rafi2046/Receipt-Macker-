import 'art_shape.dart';
import 'canvas_design.dart';

/// Canvas designs with a color band header or a dark page.
abstract final class CanvasArtsBold {
  /// A faceted diagonal header band and corner triangles at the foot.
  static const CanvasDesign prism = CanvasDesign(
    skeleton: CanvasSkeleton.band,
    headHeightMm: 46,
    shapes: [
      ArtShape.path(
        'M0 0 L1000 0 L1000 220 L0 280 Z',
        tone: ArtTone.accent,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M0 0 L560 0 L0 280 Z',
        tone: ArtTone.deep,
        opacity: 0.45,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M0 280 L1000 220 L1000 236 L0 296 Z',
        tone: ArtTone.pair,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M1000 980 L1000 1414 L360 1414 Z',
        tone: ArtTone.mist,
        opacity: 0.75,
      ),
      ArtShape.path('M1000 1230 L1000 1414 L740 1414 Z', tone: ArtTone.accent),
      ArtShape.path(
        'M0 1414 L0 1290 L190 1414 Z',
        tone: ArtTone.pair,
        opacity: 0.85,
      ),
    ],
  );

  /// A straight band with slanted stripes cutting through it.
  static const CanvasDesign sash = CanvasDesign(
    skeleton: CanvasSkeleton.band,
    headHeightMm: 37,
    shapes: [
      ArtShape.path(
        'M0 0 L1000 0 L1000 250 L0 250 Z',
        tone: ArtTone.accent,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M500 0 L565 0 L440 250 L375 250 Z',
        tone: ArtTone.pair,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M595 0 L630 0 L505 250 L470 250 Z',
        tone: ArtTone.deep,
        opacity: 0.6,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M655 0 L670 0 L545 250 L530 250 Z',
        tone: ArtTone.paper,
        opacity: 0.35,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M0 1394 L1000 1394 L1000 1414 L0 1414 Z',
        tone: ArtTone.accent,
      ),
      ArtShape.path(
        'M0 1386 L1000 1386 L1000 1394 L0 1394 Z',
        tone: ArtTone.pair,
      ),
    ],
  );

  /// Layered mountain ridges under the header and along the foot.
  static const CanvasDesign peak = CanvasDesign(
    skeleton: CanvasSkeleton.band,
    headHeightMm: 42,
    shapes: [
      ArtShape.path(
        'M0 0 L1000 0 L1000 249 L860 219 L740 269 L600 214 L460 284 '
        'L320 229 L170 274 L0 224 Z',
        tone: ArtTone.pair,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M0 0 L1000 0 L1000 227 L860 197 L740 247 L600 192 L460 262 '
        'L320 207 L170 252 L0 202 Z',
        tone: ArtTone.deep,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M0 0 L1000 0 L1000 205 L860 175 L740 225 L600 170 L460 240 '
        'L320 185 L170 230 L0 180 Z',
        tone: ArtTone.accent,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M0 1414 L0 1330 L150 1280 L300 1350 L480 1262 L650 1340 L820 1272 '
        'L1000 1330 L1000 1414 Z',
        tone: ArtTone.mist,
        opacity: 0.9,
      ),
      ArtShape.path(
        'M0 1414 L0 1370 L200 1330 L380 1390 L560 1320 L760 1385 L1000 1345 '
        'L1000 1414 Z',
        tone: ArtTone.accent,
        opacity: 0.35,
      ),
    ],
  );

  /// A header band of low-poly facets in shades of the brand color.
  static const CanvasDesign shard = CanvasDesign(
    skeleton: CanvasSkeleton.band,
    headHeightMm: 41,
    shapes: [
      ArtShape.path(
        'M0 0 L1000 0 L1000 270 L0 270 Z',
        tone: ArtTone.accent,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M0 0 L260 0 L120 270 L0 270 Z',
        tone: ArtTone.deep,
        opacity: 0.55,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M260 0 L520 0 L380 140 Z',
        tone: ArtTone.deep,
        opacity: 0.3,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M380 140 L520 0 L640 270 L300 270 Z',
        tone: ArtTone.deep,
        opacity: 0.2,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M640 270 L760 0 L1000 0 L1000 120 Z',
        tone: ArtTone.deep,
        opacity: 0.4,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M760 0 L1000 120 L1000 0 Z',
        tone: ArtTone.pair,
        opacity: 0.55,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M1000 120 L1000 270 L640 270 Z',
        tone: ArtTone.paper,
        opacity: 0.12,
        firstPageOnly: true,
      ),
      ArtShape.path(
        'M0 270 L1000 270 L1000 282 L0 282 Z',
        tone: ArtTone.pair,
        firstPageOnly: true,
      ),
      ArtShape.path('M1000 1414 L1000 1290 L880 1414 Z', tone: ArtTone.accent),
      ArtShape.path(
        'M1000 1290 L1000 1230 L940 1290 Z',
        tone: ArtTone.pair,
        opacity: 0.8,
      ),
    ],
  );

  /// A dark page with large facets rising from the bottom right.
  static const CanvasDesign nocturne = CanvasDesign(
    skeleton: CanvasSkeleton.dark,
    base: ArtTone.deep,
    shapes: [
      ArtShape.path(
        'M520 0 L1000 0 L1000 460 Z',
        tone: ArtTone.paper,
        opacity: 0.06,
      ),
      ArtShape.path(
        'M1000 620 L1000 1414 L330 1414 Z',
        tone: ArtTone.accent,
        opacity: 0.5,
      ),
      ArtShape.path(
        'M0 1414 L0 920 L620 1414 Z',
        tone: ArtTone.ink,
        opacity: 0.35,
      ),
      ArtShape.path(
        'M1000 580 L1000 640 L380 1414 L330 1414 Z',
        tone: ArtTone.pair,
        opacity: 0.8,
      ),
      ArtShape.path(
        'M1000 980 L1000 1414 L640 1414 Z',
        tone: ArtTone.ink,
        opacity: 0.3,
      ),
    ],
  );

  /// A dark page with glowing waves at the foot.
  static const CanvasDesign dusk = CanvasDesign(
    skeleton: CanvasSkeleton.dark,
    base: ArtTone.deep,
    shapes: [
      ArtShape.circle(940, 60, 260, tone: ArtTone.accent, opacity: 0.3),
      ArtShape.circle(940, 60, 150, tone: ArtTone.paper, opacity: 0.06),
      ArtShape.path(
        'M0 1180 C220 1100 380 1260 600 1190 C780 1130 900 1170 1000 1140 '
        'L1000 1414 L0 1414 Z',
        tone: ArtTone.accent,
        opacity: 0.45,
      ),
      ArtShape.path(
        'M0 1270 C200 1210 420 1340 640 1270 C820 1215 920 1260 1000 1240 '
        'L1000 1414 L0 1414 Z',
        tone: ArtTone.paper,
        opacity: 0.08,
      ),
      ArtShape.path(
        'M0 1340 C260 1300 500 1390 760 1340 C880 1318 950 1330 1000 1325 '
        'L1000 1414 L0 1414 Z',
        tone: ArtTone.ink,
        opacity: 0.35,
      ),
    ],
  );

  /// A near-black page with sharp brand-color stripes.
  static const CanvasDesign carbon = CanvasDesign(
    skeleton: CanvasSkeleton.dark,
    base: ArtTone.ink,
    shapes: [
      ArtShape.path('M700 0 L1000 0 L1000 70 L630 70 Z', tone: ArtTone.accent),
      ArtShape.path('M600 0 L680 0 L610 70 L530 70 Z', tone: ArtTone.pair),
      ArtShape.path(
        'M1000 1160 L1000 1414 L700 1414 Z',
        tone: ArtTone.accent,
        opacity: 0.9,
      ),
      ArtShape.path(
        'M1000 1060 L1000 1110 L660 1414 L600 1414 Z',
        tone: ArtTone.pair,
      ),
      ArtShape.path(
        'M0 1414 L0 1300 L130 1414 Z',
        tone: ArtTone.accent,
        opacity: 0.6,
      ),
    ],
  );
}
