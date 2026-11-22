import '../pdf_palette.dart';
import 'canvas_design.dart';

/// Styles shared by the canvas designs: the base layout, then the colors
/// of each [CanvasSkeleton].
abstract final class CanvasCss {
  static const String base =
      '''
html, body { background: transparent; }
.cv-head { display: flex; justify-content: space-between; gap: 10mm;
  align-items: flex-start; margin-bottom: 6mm; }
.cv-title { font-size: 26pt; font-weight: 400; letter-spacing: 2px;
  text-transform: uppercase; line-height: 1.1; color: ${PdfPalette.brand}; }
.cv-num { font-size: 10.5pt; font-weight: 700; margin-top: 1mm; }
.cv-meta { min-width: 62mm; }
.cv-meta .meta td:first-child { font-weight: 700; text-transform: uppercase;
  font-size: 8pt; letter-spacing: 0.5px; }
.cv-parties { display: flex; gap: 10mm; padding-top: 4mm; margin-bottom: 6mm;
  border-top: 1px solid ${PdfPalette.line}; }
.cv-party { flex: 1; }
.cv-party .party-name { font-size: 10.5pt; }
.items { border: 1px solid ${PdfPalette.line}; }
.items th { background: ${PdfPalette.deep}; color: #FFFFFF; }
.items td { background: #FFFFFF; border-right: 1px solid ${PdfPalette.line}; }
.items td:last-child { border-right: 0; }
.items tbody tr:nth-child(even) td { background: #FFFFFF
  linear-gradient(${PdfPalette.brandSoft}, ${PdfPalette.brandSoft}); }
.totals td { border-bottom: 1px solid ${PdfPalette.line}; }
.totals .grand td { background: ${PdfPalette.brand}; color: #FFFFFF;
  border-bottom: 0; text-transform: uppercase; font-size: 11pt; }
.label { color: ${PdfPalette.brand}; }
''';

  static String skeleton(CanvasDesign design) => switch (design.skeleton) {
    // The logo-first skeletons are styled by CanvasLogoCss.
    CanvasSkeleton.sheet ||
    CanvasSkeleton.brand ||
    CanvasSkeleton.card ||
    CanvasSkeleton.clean => '',
    CanvasSkeleton.band => _band,
    CanvasSkeleton.dark => _dark,
  };

  static const String _band = '''
.cv-head, .cv-head .meta td, .cv-head .meta td:first-child,
.cv-title { color: #FFFFFF; }
.cv-head .meta td:first-child { opacity: 0.8; }
.cv-head .stamp { color: #FFFFFF; }
.cv-parties { border-top: 0; }
''';

  static const String _dark =
      '''
.cv { color: #FFFFFF; }
.cv .muted, .cv .meta td:first-child, .cv .totals td:first-child
  { color: rgba(255, 255, 255, 0.72); }
.cv-title, .cv .label, .cv .note-h { color: var(--cv-hi); }
.cv-parties { border-top-color: rgba(255, 255, 255, 0.25); }
.cv .items { border-color: transparent; }
.cv .items td { color: #111827; }
.cv .items td .muted { color: #6B7280; }
.cv .totals td { border-bottom-color: rgba(255, 255, 255, 0.2); }
.cv .totals .grand td { background: var(--cv-hi); color: #111827; }
.cv .sign-line { border-top-color: rgba(255, 255, 255, 0.5); }
.cv .logo { background: #FFFFFF; padding: 1.5mm; border-radius: 2mm; }
.cv .items th { background: ${PdfPalette.brand}; }
''';
}
