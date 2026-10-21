/// How many sample lines the preview lays out.
const int billSampleCount = 8;

/// One sample line. Money is minor units. [name] is already localized.
class BillLine {
  const BillLine({
    required this.name,
    required this.detail,
    required this.totalMinor,
  });

  final String name;
  final String detail;
  final int totalMinor;
}

/// How many pages [lines] need on [perPage].
int billPageCount(int lineCount, int perPage) {
  if (lineCount <= 0) return 1;
  return (lineCount + perPage - 1) ~/ perPage;
}

/// Lines that belong on [page], counting from zero.
List<BillLine> billLinesForPage(List<BillLine> lines, int page, int perPage) {
  final start = page * perPage;
  if (start >= lines.length) return const [];
  final end = start + perPage;
  return lines.sublist(start, end > lines.length ? lines.length : end);
}
