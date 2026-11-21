/// Which of the design's colors a shape is painted with.
enum ArtTone {
  /// The chosen brand color.
  accent,

  /// A darker shade of it.
  deep,

  /// The contrasting highlight (often gold).
  pair,

  /// A pale wash of the brand color.
  soft,

  /// White.
  paper,

  /// Light neutral grey.
  mist,

  /// Near-black.
  ink,
}

/// One piece of page art, drawn on a 1000 × 1414 canvas (A4 proportions).
///
/// A shape is either an SVG-style path (absolute `M`, `L`, `C`, `Q`, `Z`
/// only, so the app can draw the same art in its previews) or a circle.
class ArtShape {
  const ArtShape.path(
    String this.d, {
    required this.tone,
    this.opacity = 1,
    this.stroke = 0,
    this.firstPageOnly = false,
  }) : cx = 0,
       cy = 0,
       r = 0;

  const ArtShape.circle(
    this.cx,
    this.cy,
    this.r, {
    required this.tone,
    this.opacity = 1,
    this.stroke = 0,
    this.firstPageOnly = false,
  }) : d = null;

  /// Canvas size every shape is drawn on.
  static const double width = 1000;
  static const double height = 1414;

  final String? d;
  final double cx;
  final double cy;
  final double r;
  final ArtTone tone;
  final double opacity;

  /// Line width; 0 fills the shape instead.
  final double stroke;

  /// Drawn only on the first page; later pages stay calmer.
  final bool firstPageOnly;

  bool get isCircle => d == null;
}
