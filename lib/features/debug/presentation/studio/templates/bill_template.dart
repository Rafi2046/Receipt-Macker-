import 'bill_colors.dart';
import 'bill_kinds.dart';

/// One curated combination of layout, header, and palette.
class BillTemplate {
  const BillTemplate({
    required this.id,
    required this.name,
    required this.layout,
    required this.header,
    required this.colors,
    required this.category,
    required this.pro,
  });

  final String id;
  final String name;
  final BillLayout layout;
  final BillHeader header;
  final BillColors colors;
  final BillCategory category;
  final bool pro;

  /// Thermal paper cannot hold a side-by-side header, so it stacks.
  BillLayout layoutFor(BillPaper paper) =>
      paper.isThermal ? BillLayout.compact : layout;
}
