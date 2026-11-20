import 'brand_swatch.dart';
import 'pdf_template.dart';
import 'pdf_template_category.dart';

/// The curated gallery data: for each browse tab, the layouts shown there
/// and the colors each one comes in. A layout × color pair appears once.
abstract final class PdfTemplatePicks {
  static const List<
    (PdfTemplateCategory, List<(PdfTemplate, List<BrandSwatch>)>)
  >
  all = [
    (
      PdfTemplateCategory.recommend,
      [
        (PdfTemplate.classic, [BrandSwatch.coral]),
        (PdfTemplate.minimal, [BrandSwatch.slate]),
        (PdfTemplate.compact, [BrandSwatch.teal]),
        (PdfTemplate.aurora, [BrandSwatch.royal]),
        (PdfTemplate.prestige, [BrandSwatch.midnight]),
        (PdfTemplate.modern, [BrandSwatch.navy]),
        (PdfTemplate.pillar, [BrandSwatch.navy]),
        (PdfTemplate.executive, [BrandSwatch.emerald]),
        (PdfTemplate.crest, [BrandSwatch.ocean]),
        (PdfTemplate.studio, [BrandSwatch.indigo]),
        (PdfTemplate.duo, [BrandSwatch.emerald]),
        (PdfTemplate.onyx, [BrandSwatch.coral]),
        (PdfTemplate.ledger, [BrandSwatch.charcoal]),
        (PdfTemplate.vertex, [BrandSwatch.crimson]),
        (PdfTemplate.editorial, [BrandSwatch.crimson]),
        (PdfTemplate.halo, [BrandSwatch.violet]),
        (PdfTemplate.nordic, [BrandSwatch.slate]),
        (PdfTemplate.folio, [BrandSwatch.charcoal]),
        (PdfTemplate.atelier, [BrandSwatch.stone]),
        (PdfTemplate.lumen, [BrandSwatch.navy]),
      ],
    ),
    (
      PdfTemplateCategory.simple,
      [
        (PdfTemplate.minimal, [BrandSwatch.coral, BrandSwatch.navy]),
        (PdfTemplate.compact, [BrandSwatch.coral, BrandSwatch.slate]),
        (
          PdfTemplate.nordic,
          [BrandSwatch.charcoal, BrandSwatch.stone, BrandSwatch.olive],
        ),
        (PdfTemplate.folio, [BrandSwatch.slate, BrandSwatch.stone]),
        (
          PdfTemplate.pinstripe,
          [
            BrandSwatch.slate,
            BrandSwatch.navy,
            BrandSwatch.forest,
            BrandSwatch.bronze,
          ],
        ),
      ],
    ),
    (
      PdfTemplateCategory.classic,
      [
        (
          PdfTemplate.classic,
          [BrandSwatch.navy, BrandSwatch.emerald, BrandSwatch.charcoal],
        ),
        (
          PdfTemplate.ledger,
          [
            BrandSwatch.navy,
            BrandSwatch.emerald,
            BrandSwatch.coral,
            BrandSwatch.wine,
          ],
        ),
        (
          PdfTemplate.ribbon,
          [
            BrandSwatch.crimson,
            BrandSwatch.navy,
            BrandSwatch.emerald,
            BrandSwatch.bronze,
            BrandSwatch.royal,
          ],
        ),
      ],
    ),
    (
      PdfTemplateCategory.professional,
      [
        (
          PdfTemplate.executive,
          [
            BrandSwatch.navy,
            BrandSwatch.charcoal,
            BrandSwatch.coral,
            BrandSwatch.indigo,
            BrandSwatch.royal,
            BrandSwatch.forest,
            BrandSwatch.wine,
          ],
        ),
        (
          PdfTemplate.studio,
          [
            BrandSwatch.navy,
            BrandSwatch.emerald,
            BrandSwatch.coral,
            BrandSwatch.charcoal,
          ],
        ),
        (PdfTemplate.folio, [BrandSwatch.navy]),
        (PdfTemplate.lumen, [BrandSwatch.slate, BrandSwatch.emerald]),
        (
          PdfTemplate.pillar,
          [
            BrandSwatch.slate,
            BrandSwatch.emerald,
            BrandSwatch.charcoal,
            BrandSwatch.wine,
            BrandSwatch.teal,
          ],
        ),
        (
          PdfTemplate.duo,
          [
            BrandSwatch.navy,
            BrandSwatch.royal,
            BrandSwatch.slate,
            BrandSwatch.teal,
          ],
        ),
        (PdfTemplate.metro, [BrandSwatch.navy, BrandSwatch.slate]),
      ],
    ),
    (
      PdfTemplateCategory.modern,
      [
        (
          PdfTemplate.modern,
          [
            BrandSwatch.coral,
            BrandSwatch.teal,
            BrandSwatch.crimson,
            BrandSwatch.indigo,
            BrandSwatch.violet,
            BrandSwatch.ocean,
          ],
        ),
        (
          PdfTemplate.editorial,
          [
            BrandSwatch.navy,
            BrandSwatch.teal,
            BrandSwatch.amber,
            BrandSwatch.coral,
          ],
        ),
        (PdfTemplate.atelier, [BrandSwatch.navy, BrandSwatch.teal]),
        (PdfTemplate.lumen, [BrandSwatch.stone]),
        (PdfTemplate.nordic, [BrandSwatch.navy]),
        (
          PdfTemplate.aurora,
          [
            BrandSwatch.indigo,
            BrandSwatch.teal,
            BrandSwatch.emerald,
            BrandSwatch.rose,
          ],
        ),
        (
          PdfTemplate.halo,
          [
            BrandSwatch.royal,
            BrandSwatch.emerald,
            BrandSwatch.rose,
            BrandSwatch.coral,
          ],
        ),
        (PdfTemplate.crest, [BrandSwatch.navy, BrandSwatch.teal]),
      ],
    ),
    (
      PdfTemplateCategory.creative,
      [
        (
          PdfTemplate.orbit,
          [
            BrandSwatch.coral,
            BrandSwatch.royal,
            BrandSwatch.violet,
            BrandSwatch.emerald,
            BrandSwatch.rose,
            BrandSwatch.amber,
          ],
        ),
        (
          PdfTemplate.vertex,
          [
            BrandSwatch.navy,
            BrandSwatch.indigo,
            BrandSwatch.teal,
            BrandSwatch.plum,
          ],
        ),
        (PdfTemplate.crest, [BrandSwatch.plum, BrandSwatch.rose]),
        (
          PdfTemplate.metro,
          [
            BrandSwatch.coral,
            BrandSwatch.violet,
            BrandSwatch.ocean,
            BrandSwatch.emerald,
          ],
        ),
        (PdfTemplate.halo, [BrandSwatch.plum, BrandSwatch.ocean]),
        (PdfTemplate.aurora, [BrandSwatch.plum, BrandSwatch.ocean]),
      ],
    ),
    (
      PdfTemplateCategory.elegant,
      [
        (
          PdfTemplate.prestige,
          [
            BrandSwatch.navy,
            BrandSwatch.charcoal,
            BrandSwatch.wine,
            BrandSwatch.forest,
            BrandSwatch.emerald,
            BrandSwatch.plum,
          ],
        ),
        (
          PdfTemplate.regal,
          [
            BrandSwatch.navy,
            BrandSwatch.crimson,
            BrandSwatch.forest,
            BrandSwatch.bronze,
            BrandSwatch.wine,
            BrandSwatch.charcoal,
          ],
        ),
        (PdfTemplate.pinstripe, [BrandSwatch.wine, BrandSwatch.charcoal]),
        (PdfTemplate.ribbon, [BrandSwatch.wine]),
        (PdfTemplate.pillar, [BrandSwatch.midnight]),
        (PdfTemplate.executive, [BrandSwatch.midnight]),
        (PdfTemplate.aurora, [BrandSwatch.midnight]),
      ],
    ),
    (
      PdfTemplateCategory.bold,
      [
        (
          PdfTemplate.onyx,
          [
            BrandSwatch.amber,
            BrandSwatch.rose,
            BrandSwatch.royal,
            BrandSwatch.violet,
            BrandSwatch.ocean,
            BrandSwatch.emerald,
          ],
        ),
        (
          PdfTemplate.impact,
          [
            BrandSwatch.coral,
            BrandSwatch.navy,
            BrandSwatch.crimson,
            BrandSwatch.emerald,
            BrandSwatch.royal,
            BrandSwatch.charcoal,
            BrandSwatch.violet,
          ],
        ),
        (PdfTemplate.vertex, [BrandSwatch.coral, BrandSwatch.charcoal]),
        (
          PdfTemplate.duo,
          [BrandSwatch.coral, BrandSwatch.crimson, BrandSwatch.plum],
        ),
        (PdfTemplate.metro, [BrandSwatch.crimson]),
      ],
    ),
  ];
}
