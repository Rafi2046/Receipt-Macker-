/// The PDF designs. [id] is stable (stored in preferences, analytics).
enum PdfTemplate {
  classic('classic'),
  minimal('minimal'),
  modern('modern'),
  executive('executive'),
  studio('studio'),
  editorial('editorial'),
  compact('compact'),
  ledger('ledger');

  const PdfTemplate(this.id);

  final String id;

  /// Classic is free. All 7 other designs are Pro.
  bool get requiresPro => this != PdfTemplate.classic;

  static PdfTemplate fromId(String? id) =>
      values.firstWhere((t) => t.id == id, orElse: () => classic);
}
