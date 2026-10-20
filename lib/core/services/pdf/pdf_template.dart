/// The PDF designs. [id] is stable (stored in preferences, analytics).
enum PdfTemplate {
  classic('classic'),
  modern('modern'),
  minimal('minimal');

  const PdfTemplate(this.id);

  final String id;

  static PdfTemplate fromId(String? id) =>
      values.firstWhere((t) => t.id == id, orElse: () => classic);
}
