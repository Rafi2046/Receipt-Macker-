/// The PDF designs. [id] is stable (stored in preferences, analytics).
enum PdfTemplate {
  classic('classic'),
  minimal('minimal'),
  modern('modern'),
  executive('executive'),
  studio('studio'),
  editorial('editorial'),
  compact('compact'),
  ledger('ledger'),
  nordic('nordic'),
  folio('folio'),
  atelier('atelier'),
  lumen('lumen'),
  aurora('aurora'),
  prestige('prestige'),
  vertex('vertex'),
  pillar('pillar'),
  crest('crest'),
  orbit('orbit'),
  ribbon('ribbon'),
  onyx('onyx'),
  metro('metro'),
  regal('regal'),
  duo('duo'),
  halo('halo'),
  pinstripe('pinstripe'),
  impact('impact');

  const PdfTemplate(this.id);

  final String id;

  /// The layouts a free account may use, in any color.
  static const Set<PdfTemplate> freeLayouts = {classic, minimal, compact};

  /// Classic, Minimal and Compact are free. All other designs are Pro.
  bool get requiresPro => !freeLayouts.contains(this);

  static PdfTemplate fromId(String? id) =>
      values.firstWhere((t) => t.id == id, orElse: () => classic);
}
