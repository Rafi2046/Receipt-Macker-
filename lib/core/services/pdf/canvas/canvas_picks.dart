import '../brand_swatch.dart';
import '../pdf_template.dart';
import '../pdf_template_category.dart';

/// Gallery data for the full-page art designs, by browse tab: the layouts
/// shown there and the colors each one comes in.
abstract final class CanvasPicks {
  static const List<
    (PdfTemplateCategory, List<(PdfTemplate, List<BrandSwatch>)>)
  >
  all = [
    (
      PdfTemplateCategory.recommend,
      [
        (PdfTemplate.wave, [BrandSwatch.emerald]),
        (PdfTemplate.prism, [BrandSwatch.navy]),
        (PdfTemplate.nocturne, [BrandSwatch.coral]),
        (PdfTemplate.tide, [BrandSwatch.royal]),
      ],
    ),
    (
      PdfTemplateCategory.simple,
      [
        (
          PdfTemplate.lattice,
          [BrandSwatch.slate, BrandSwatch.navy, BrandSwatch.forest],
        ),
        (
          PdfTemplate.halftone,
          [BrandSwatch.slate, BrandSwatch.coral, BrandSwatch.teal],
        ),
        (PdfTemplate.frame, [BrandSwatch.charcoal, BrandSwatch.stone]),
      ],
    ),
    (
      PdfTemplateCategory.classic,
      [
        (
          PdfTemplate.frame,
          [
            BrandSwatch.navy,
            BrandSwatch.emerald,
            BrandSwatch.crimson,
            BrandSwatch.bronze,
          ],
        ),
        (
          PdfTemplate.corner,
          [
            BrandSwatch.navy,
            BrandSwatch.charcoal,
            BrandSwatch.emerald,
            BrandSwatch.wine,
          ],
        ),
      ],
    ),
    (
      PdfTemplateCategory.professional,
      [
        (
          PdfTemplate.prism,
          [
            BrandSwatch.emerald,
            BrandSwatch.charcoal,
            BrandSwatch.royal,
            BrandSwatch.wine,
          ],
        ),
        (
          PdfTemplate.mesh,
          [
            BrandSwatch.navy,
            BrandSwatch.teal,
            BrandSwatch.slate,
            BrandSwatch.indigo,
          ],
        ),
        (
          PdfTemplate.tide,
          [BrandSwatch.navy, BrandSwatch.emerald, BrandSwatch.charcoal],
        ),
        (
          PdfTemplate.sash,
          [BrandSwatch.navy, BrandSwatch.forest, BrandSwatch.midnight],
        ),
      ],
    ),
    (
      PdfTemplateCategory.modern,
      [
        (
          PdfTemplate.wave,
          [
            BrandSwatch.navy,
            BrandSwatch.coral,
            BrandSwatch.teal,
            BrandSwatch.violet,
          ],
        ),
        (
          PdfTemplate.bubble,
          [
            BrandSwatch.indigo,
            BrandSwatch.teal,
            BrandSwatch.rose,
            BrandSwatch.amber,
            BrandSwatch.ocean,
          ],
        ),
        (
          PdfTemplate.hive,
          [
            BrandSwatch.navy,
            BrandSwatch.emerald,
            BrandSwatch.amber,
            BrandSwatch.charcoal,
          ],
        ),
        (
          PdfTemplate.shard,
          [
            BrandSwatch.indigo,
            BrandSwatch.teal,
            BrandSwatch.royal,
            BrandSwatch.emerald,
          ],
        ),
      ],
    ),
    (
      PdfTemplateCategory.creative,
      [
        (
          PdfTemplate.wave,
          [BrandSwatch.rose, BrandSwatch.plum, BrandSwatch.ocean],
        ),
        (
          PdfTemplate.peak,
          [
            BrandSwatch.emerald,
            BrandSwatch.ocean,
            BrandSwatch.forest,
            BrandSwatch.coral,
            BrandSwatch.violet,
          ],
        ),
        (
          PdfTemplate.halftone,
          [BrandSwatch.violet, BrandSwatch.rose, BrandSwatch.royal],
        ),
        (PdfTemplate.tide, [BrandSwatch.rose, BrandSwatch.plum]),
        (PdfTemplate.lattice, [BrandSwatch.coral, BrandSwatch.violet]),
        (PdfTemplate.bubble, [BrandSwatch.violet, BrandSwatch.coral]),
        (PdfTemplate.corner, [BrandSwatch.coral, BrandSwatch.violet]),
        (
          PdfTemplate.shard,
          [BrandSwatch.plum, BrandSwatch.rose, BrandSwatch.coral],
        ),
      ],
    ),
    (
      PdfTemplateCategory.elegant,
      [
        (
          PdfTemplate.frame,
          [
            BrandSwatch.wine,
            BrandSwatch.forest,
            BrandSwatch.plum,
            BrandSwatch.midnight,
          ],
        ),
        (
          PdfTemplate.nocturne,
          [
            BrandSwatch.navy,
            BrandSwatch.forest,
            BrandSwatch.wine,
            BrandSwatch.charcoal,
          ],
        ),
        (
          PdfTemplate.dusk,
          [
            BrandSwatch.navy,
            BrandSwatch.emerald,
            BrandSwatch.plum,
            BrandSwatch.wine,
            BrandSwatch.midnight,
          ],
        ),
        (PdfTemplate.corner, [BrandSwatch.bronze, BrandSwatch.midnight]),
      ],
    ),
    (
      PdfTemplateCategory.bold,
      [
        (
          PdfTemplate.nocturne,
          [
            BrandSwatch.emerald,
            BrandSwatch.royal,
            BrandSwatch.violet,
            BrandSwatch.teal,
          ],
        ),
        (
          PdfTemplate.carbon,
          [
            BrandSwatch.amber,
            BrandSwatch.coral,
            BrandSwatch.rose,
            BrandSwatch.royal,
            BrandSwatch.emerald,
            BrandSwatch.violet,
          ],
        ),
        (PdfTemplate.dusk, [BrandSwatch.coral, BrandSwatch.indigo]),
        (
          PdfTemplate.sash,
          [
            BrandSwatch.crimson,
            BrandSwatch.coral,
            BrandSwatch.emerald,
            BrandSwatch.royal,
          ],
        ),
        (PdfTemplate.prism, [BrandSwatch.crimson, BrandSwatch.coral]),
      ],
    ),
  ];
}
