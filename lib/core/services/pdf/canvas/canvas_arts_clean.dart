import 'art_shape.dart';
import 'canvas_design.dart';

/// Quiet canvas designs: a white page, the logo header and fine lines.
abstract final class CanvasArtsClean {
  /// A slim color rule across the top and the foot.
  static const CanvasDesign linea = CanvasDesign(
    skeleton: CanvasSkeleton.clean,
    marginTopMm: 17,
    marginSideMm: 16,
    shapes: [
      ArtShape.path('M0 0 L1000 0 L1000 12 L0 12 Z', tone: ArtTone.accent),
      ArtShape.path(
        'M0 1406 L1000 1406 L1000 1414 L0 1414 Z',
        tone: ArtTone.accent,
      ),
    ],
  );

  /// A color spine down the left edge.
  static const CanvasDesign margin = CanvasDesign(
    skeleton: CanvasSkeleton.clean,
    marginTopMm: 16,
    marginSideMm: 19,
    shapes: [
      ArtShape.path('M0 0 L26 0 L26 1414 L0 1414 Z', tone: ArtTone.accent),
      ArtShape.path('M26 0 L32 0 L32 1414 L26 1414 Z', tone: ArtTone.pair),
    ],
  );

  /// Fine corner brackets, like a certificate.
  static const CanvasDesign quartz = CanvasDesign(
    skeleton: CanvasSkeleton.clean,
    marginTopMm: 19,
    marginSideMm: 19,
    marginBottomMm: 19,
    shapes: [
      ArtShape.path('M38 150 L38 38 L150 38', tone: ArtTone.accent, stroke: 4),
      ArtShape.path(
        'M962 1264 L962 1376 L850 1376',
        tone: ArtTone.accent,
        stroke: 4,
      ),
      ArtShape.path(
        'M962 150 L962 38 L850 38',
        tone: ArtTone.pair,
        stroke: 1.5,
      ),
      ArtShape.path(
        'M38 1264 L38 1376 L150 1376',
        tone: ArtTone.pair,
        stroke: 1.5,
      ),
    ],
  );

  /// Soft rings glowing from two corners.
  static const CanvasDesign pearl = CanvasDesign(
    skeleton: CanvasSkeleton.clean,
    marginTopMm: 16,
    marginSideMm: 16,
    shapes: [
      ArtShape.circle(1000, 0, 360, tone: ArtTone.accent, opacity: 0.06),
      ArtShape.circle(1000, 0, 250, tone: ArtTone.accent, opacity: 0.07),
      ArtShape.circle(1000, 0, 140, tone: ArtTone.accent, opacity: 0.1),
      ArtShape.circle(0, 1414, 240, tone: ArtTone.accent, opacity: 0.06),
      ArtShape.circle(0, 1414, 130, tone: ArtTone.accent, opacity: 0.08),
      ArtShape.path('M76 0 L196 0 L196 10 L76 10 Z', tone: ArtTone.accent),
    ],
  );
}
