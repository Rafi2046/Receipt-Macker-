/// Where the circular status stamp sits on page 1 of an invoice PDF.
enum StampPlacement {
  center,
  topRight,
  bottomRight;

  static StampPlacement fromId(String? id) => switch (id) {
    'topRight' => StampPlacement.topRight,
    'bottomRight' => StampPlacement.bottomRight,
    _ => StampPlacement.center,
  };

  String get id => name;
}
