/// Where the circular status stamp sits on page 1 of an invoice PDF.
enum StampPlacement {
  /// No seal on the PDF.
  none,
  center,
  topRight,
  bottomRight;

  static StampPlacement fromId(String? id) => switch (id) {
    'none' => StampPlacement.none,
    'topRight' => StampPlacement.topRight,
    'bottomRight' => StampPlacement.bottomRight,
    _ => StampPlacement.center,
  };

  String get id => name;

  /// Whether a circular seal should be drawn.
  bool get showsSeal => this != StampPlacement.none;
}
