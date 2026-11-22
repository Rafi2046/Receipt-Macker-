import 'art_shape.dart';

/// How the content sits on a canvas design's art.
enum CanvasSkeleton {
  /// Dark text on a light page; the header is plain.
  sheet,

  /// The header sits on a color band of the art, in white.
  band,

  /// Light text on a dark page; the item rows stay white.
  dark,

  /// Logo and seller on a full-width color header that grows with its
  /// text, the title on the right; white page below.
  brand,

  /// The same header straight on a colored page; the rest sits on a white
  /// rounded card.
  card,

  /// The logo header in dark text on a white page, with quiet line work.
  clean,
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
    this.headShapes = const [],
    this.edgeShapes = const [],
    this.headBase = ArtTone.accent,
    this.edgeMm = 0,
    this.headInk = false,
  });

  /// Canvas the [headShapes] are drawn on; scaled to cover the header.
  static const double headWidth = 1000;
  static const double headHeight = 280;

  /// Canvas the [edgeShapes] are drawn on; stretched over the edge strip.
  static const double edgeWidth = 1000;
  static const double edgeHeight = 100;

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

  /// [CanvasSkeleton.brand] only: art inside the color header.
  final List<ArtShape> headShapes;

  /// [CanvasSkeleton.brand] only: the header's lower edge (a wave, a
  /// slant), [edgeMm] tall. Paper-toned shapes cut the header away.
  final List<ArtShape> edgeShapes;

  /// The header's own color under [headShapes].
  final ArtTone headBase;
  final double edgeMm;

  /// The seller's text in the header is dark (on a pale header).
  final bool headInk;

  bool get isDark => skeleton == CanvasSkeleton.dark;

  /// The logo-first header: logo and seller left, title right.
  bool get hasLogoHead =>
      skeleton == CanvasSkeleton.brand ||
      skeleton == CanvasSkeleton.card ||
      skeleton == CanvasSkeleton.clean;

  /// The page margin is colored, so the page number prints in white.
  bool get footOnColor => isDark || skeleton == CanvasSkeleton.card;

  /// Every shape of the design, wherever it is drawn.
  Iterable<ArtShape> get allShapes => [...shapes, ...headShapes, ...edgeShapes];
}
