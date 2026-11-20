/// Paper size of generated PDFs. A4 is the default (most of the world);
/// Letter and Legal are for North America, A5 for small bills.
enum PdfPageSize {
  a4('a4', 'A4'),
  letter('letter', 'letter'),
  legal('legal', 'legal'),
  a5('a5', 'A5');

  const PdfPageSize(this.id, this.cssName);

  /// Stable id: stored in preferences and sent to the native bridge.
  final String id;

  /// The CSS `@page size` keyword.
  final String cssName;

  static PdfPageSize fromId(String? id) =>
      values.firstWhere((s) => s.id == id, orElse: () => a4);
}
