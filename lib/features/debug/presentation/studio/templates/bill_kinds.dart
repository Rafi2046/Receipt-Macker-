/// How the page is arranged. Thermal paper uses [BillLayout.compact].
enum BillLayout {
  split,
  stack,
  band,
  sidebar,
  centered,
  compact,
  statement,
  ruled,
}

/// A decoration drawn in code. No images.
enum BillHeader { plain, rule, block, corner, ribbon, wave }

/// Gallery group.
enum BillCategory { recommended, simple, classic, professional, creative }

/// Paper the preview can show. Thermal widths stack the header.
enum BillPaper { a4, letter, mm58, mm80 }

/// Width of the unscaled page, in logical pixels.
extension BillPaperSize on BillPaper {
  bool get isThermal => this == BillPaper.mm58 || this == BillPaper.mm80;

  double get width => switch (this) {
    BillPaper.a4 || BillPaper.letter => 340,
    BillPaper.mm58 => 200,
    BillPaper.mm80 => 250,
  };

  int get linesPerPage => isThermal ? 4 : 5;
}
