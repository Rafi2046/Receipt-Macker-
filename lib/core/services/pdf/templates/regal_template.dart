import '../models/pdf_document.dart';
import '../pdf_blocks.dart';
import '../pdf_html.dart';
import '../pdf_palette.dart';

/// Regal: a centered letterhead inside a fine double frame, with an
/// ornament rule.
abstract final class RegalTemplate {
  static String body(PdfDocument doc) =>
      '''
<div class="rg-head keep">
  ${PdfHtml.logo(doc.seller)}
  <div class="rg-name">${PdfHtml.esc(doc.seller.name)}</div>
  ${PdfBlocks.sellerLines(doc, cls: 'rg-line')}
  <div class="rg-orn"><i></i><b></b><i></i></div>
  <div class="rg-title">${PdfHtml.esc(doc.title)}</div>
  <div class="rg-num">${PdfHtml.esc(doc.number)}</div>
  ${PdfBlocks.stamp(doc)}
</div>
<div class="rg-row keep">
  <div>${PdfBlocks.buyer(doc)}</div>
  <div class="rg-meta">${PdfBlocks.meta(doc)}</div>
</div>
${PdfBlocks.rest(doc)}
''';

  static const String css =
      '''
.rg-head { text-align: center; margin-bottom: 7mm; padding: 8mm 10mm 7mm;
  border: 0.6mm solid ${PdfPalette.brand};
  outline: 0.25mm solid ${PdfPalette.pair}; outline-offset: -2.2mm; }
.rg-name { font-size: 16pt; font-weight: 700; letter-spacing: 2px;
  text-transform: uppercase; color: ${PdfPalette.brand}; margin-top: 1.5mm; }
.rg-line { font-size: 8.5pt; color: ${PdfPalette.muted}; }
.rg-orn { display: flex; align-items: center; justify-content: center;
  gap: 3mm; margin: 4.5mm 0 3.5mm; }
.rg-orn i { width: 32mm; height: 1px; background: ${PdfPalette.pair}; }
.rg-orn b { width: 2.4mm; height: 2.4mm; background: ${PdfPalette.pair};
  transform: rotate(45deg); }
.rg-title { font-size: 13pt; font-weight: 700; letter-spacing: 6px;
  text-transform: uppercase; color: ${PdfPalette.ink}; }
.rg-num { font-size: 10.5pt; color: ${PdfPalette.muted}; }
.stamp { color: ${PdfPalette.muted}; }
.rg-row { display: flex; justify-content: space-between; gap: 10mm;
  margin-bottom: 6mm; }
.rg-meta { min-width: 64mm; }
.label { color: ${PdfPalette.brand}; }
.items th { color: ${PdfPalette.brand}; border-top: 0.5mm solid ${PdfPalette.brand};
  border-bottom: 0.5mm solid ${PdfPalette.brand}; letter-spacing: 1.2px; }
.totals .grand td { color: ${PdfPalette.brand}; border-top: 0.5mm solid ${PdfPalette.brand};
  border-bottom: 1.2mm double ${PdfPalette.brand}; }
.sign-line { border-top-color: ${PdfPalette.brand}; }
''';
}
