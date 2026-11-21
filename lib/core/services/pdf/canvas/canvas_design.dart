import 'art_shape.dart';

/// How the content sits on a canvas design's art.
enum CanvasSkeleton {
  /// Dark text on a light page; the header is plain.
  sheet,

  /// The header sits on a color band of the art, in white.
  band,

  /// Light text on a dark page; the item rows stay white.
  dark,
}

/// A premium design made of full-page art plus one of the [CanvasSkeleton]
/// layouts. The art fills the whole sheet, margins included, on every page.
class CanvasDesign {
  const CanvasDesign({
    required this.skeleton,
    required this.shapes,
    this.base = ArtTone.paper,
    this.marginTopMm = 14,
    this.marginSideMm = 14,
    this.marginBottomMm = 16,
    this.headHeightMm = 0,
  });

  final CanvasSkeleton skeleton;
  final List<ArtShape> shapes;

  /// The page color under the shapes.
  final ArtTone base;

  /// Page margins, larger where the art runs along the edges.
  final double marginTopMm;
  final double marginSideMm;
  final double marginBottomMm;

  /// Minimum header height, so the header text stays on its band of art.
  final double headHeightMm;

  bool get isDark => skeleton == CanvasSkeleton.dark;
}
