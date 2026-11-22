import 'art_shape.dart';
import 'canvas_design.dart';

/// Canvas designs on a colored page, the content on a white card.
abstract final class CanvasArtsCard {
  /// Folded corners in shades of the page color.
  static const CanvasDesign plaque = CanvasDesign(
    skeleton: CanvasSkeleton.card,
    base: ArtTone.accent,
    marginTopMm: 12,
    marginSideMm: 11,
    shapes: [
      ArtShape.path(
        'M1000 0 L1000 340 L690 0 Z',
        tone: ArtTone.deep,
        opacity: 0.5,
      ),
      ArtShape.path(
        'M0 1414 L0 1030 L430 1414 Z',
        tone: ArtTone.paper,
        opacity: 0.16,
      ),
      ArtShape.path(
        'M1000 1414 L1000 1190 L790 1414 Z',
        tone: ArtTone.deep,
        opacity: 0.5,
      ),
    ],
  );

  /// A dark diagonal foot with a bright wedge and a white stripe.
  static const CanvasDesign trio = CanvasDesign(
    skeleton: CanvasSkeleton.card,
    base: ArtTone.accent,
    marginTopMm: 12,
    marginSideMm: 11,
    shapes: [
      ArtShape.path(
        'M0 1414 L0 1250 L1000 1010 L1000 1414 Z',
        tone: ArtTone.ink,
      ),
      ArtShape.path(
        'M0 1250 L1000 1010 L1000 1032 L0 1272 Z',
        tone: ArtTone.paper,
      ),
      ArtShape.path('M500 1414 L1000 1124 L1000 1414 Z', tone: ArtTone.pair),
      ArtShape.path(
        'M1000 0 L1000 150 L880 0 Z',
        tone: ArtTone.ink,
        opacity: 0.35,
      ),
    ],
  );

  /// The page folds into lighter tints toward the foot.
  static const CanvasDesign fold = CanvasDesign(
    skeleton: CanvasSkeleton.card,
    base: ArtTone.accent,
    marginTopMm: 12,
    marginSideMm: 11,
    shapes: [
      ArtShape.path(
        'M0 1414 L0 1090 L1000 720 L1000 1414 Z',
        tone: ArtTone.paper,
        opacity: 0.18,
      ),
      ArtShape.path(
        'M0 1414 L0 1260 L1000 890 L1000 1414 Z',
        tone: ArtTone.paper,
        opacity: 0.16,
      ),
      ArtShape.path('M0 0 L300 0 L0 220 Z', tone: ArtTone.deep, opacity: 0.4),
    ],
  );
}
