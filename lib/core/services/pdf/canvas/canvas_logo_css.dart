import '../pdf_palette.dart';
import 'canvas_design.dart';

/// Styles of the logo-first canvas designs: the shared header, then what
/// each of the brand, card and clean skeletons changes.
abstract final class CanvasLogoCss {
  static String of(CanvasDesign design) =>
      '$_head${switch (design.skeleton) {
        CanvasSkeleton.brand => _onColor,
        CanvasSkeleton.card => '$_onColor$_card',
        CanvasSkeleton.clean => _clean,
        _ => '',
      }}${design.headInk ? _ink : ''}';

  static const String _head = '''
.cv-bhead { display: flex; justify-content: space-between; gap: 8mm;
  align-items: center; margin-bottom: 6mm; }
.cv-who { display: flex; align-items: center; gap: 4mm; min-width: 0; }
.cv-logo { flex: none; line-height: 0; background: #FFFFFF; padding: 1.5mm;
  border-radius: 2mm; }
.cv-logo .logo { display: block; max-height: 17mm; max-width: 34mm; }
.cv-seller { min-width: 0; }
.cv-seller .party-name { font-size: 11.5pt; line-height: 1.25; }
.cv-seller .muted { font-size: 8.5pt; line-height: 1.4; }
.cv-bhead .cv-doc { flex: none; text-align: right; }
.cv-bhead .cv-title { font-size: 25pt; font-weight: 700;
  letter-spacing: 1.5px; }
.cv-bhead .cv-num { font-size: 10pt; }
.cv-info { display: flex; justify-content: space-between; gap: 10mm;
  margin-bottom: 6mm; }
.cv-info .cv-party { flex: 1; }
''';

  static const String _onColor = '''
.cv-bhead .cv-title, .cv-bhead .cv-num, .cv-bhead .party-name,
.cv-bhead .stamp { color: #FFFFFF; }
.cv-bhead .muted { color: rgba(255, 255, 255, 0.86); }
''';

  /// A pale header: the seller's text goes dark, the title stays white.
  static const String _ink =
      '''
.cv-bhead .cv-who .party-name { color: ${PdfPalette.ink}; }
.cv-bhead .cv-who .muted { color: ${PdfPalette.muted}; }
''';

  static const String _card = '''
.cv-body { background: #FFFFFF; border-radius: 4mm; padding: 7mm 7mm 6mm;
  -webkit-box-decoration-break: clone; box-decoration-break: clone; }
''';

  static const String _clean =
      '''
.cv-logo { background: none; padding: 0; border-radius: 0; }
.cv-bhead { padding-bottom: 6mm; border-bottom: 1px solid ${PdfPalette.line}; }
.cv-bhead .cv-title { font-weight: 400; font-size: 23pt; letter-spacing: 4px; }
.cv-bhead .cv-num { color: ${PdfPalette.muted}; font-weight: 400; }
.items { border: 0; }
.items th { background: transparent; color: ${PdfPalette.ink};
  border-bottom: 1.5px solid ${PdfPalette.brand}; }
.items td { background: transparent; border-right: 0; }
.items tbody tr:nth-child(even) td { background: transparent; }
.totals .grand td { background: transparent; color: ${PdfPalette.brand};
  border-top: 1.5px solid ${PdfPalette.brand};
  border-bottom: 1.5px solid ${PdfPalette.brand}; }
''';
}
