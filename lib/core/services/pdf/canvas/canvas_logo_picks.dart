import '../brand_swatch.dart';
import '../pdf_template.dart';
import '../pdf_template_category.dart';

/// Gallery data for the logo-header designs (brand, card and clean), by
/// browse tab: the layouts shown there and the colors each one comes in.
abstract final class CanvasLogoPicks {
  static const List<
    (PdfTemplateCategory, List<(PdfTemplate, List<BrandSwatch>)>)
  >
  all = [
    (
      PdfTemplateCategory.recommend,
      [
        (PdfTemplate.swoosh, [BrandSwatch.royal]),
        (PdfTemplate.plaque, [BrandSwatch.navy]),
        (PdfTemplate.linea, [BrandSwatch.charcoal]),
        (PdfTemplate.silk, [BrandSwatch.charcoal]),
        (PdfTemplate.capsule, [BrandSwatch.teal]),
        (PdfTemplate.pearl, [BrandSwatch.slate]),
      ],
    ),
    (
      PdfTemplateCategory.simple,
      [
        (
          PdfTemplate.linea,
          [BrandSwatch.slate, BrandSwatch.navy, BrandSwatch.stone],
        ),
        (
          PdfTemplate.margin,
          [BrandSwatch.charcoal, BrandSwatch.slate, BrandSwatch.olive],
        ),
        (PdfTemplate.quartz, [BrandSwatch.charcoal, BrandSwatch.stone]),
        (PdfTemplate.pearl, [BrandSwatch.stone, BrandSwatch.teal]),
      ],
    ),
    (
      PdfTemplateCategory.classic,
      [
        (
          PdfTemplate.quartz,
          [
            BrandSwatch.navy,
            BrandSwatch.emerald,
            BrandSwatch.bronze,
            BrandSwatch.wine,
          ],
        ),
        (PdfTemplate.margin, [BrandSwatch.navy, BrandSwatch.crimson]),
      ],
    ),
    (
      PdfTemplateCategory.professional,
      [
        (
          PdfTemplate.swoosh,
          [
            BrandSwatch.navy,
            BrandSwatch.emerald,
            BrandSwatch.charcoal,
            BrandSwatch.ocean,
          ],
        ),
        (
          PdfTemplate.slant,
          [
            BrandSwatch.navy,
            BrandSwatch.ocean,
            BrandSwatch.slate,
            BrandSwatch.forest,
          ],
        ),
        (
          PdfTemplate.plaque,
          [
            BrandSwatch.midnight,
            BrandSwatch.forest,
            BrandSwatch.charcoal,
            BrandSwatch.slate,
          ],
        ),
        (
          PdfTemplate.margin,
          [BrandSwatch.emerald, BrandSwatch.royal, BrandSwatch.indigo],
        ),
        (
          PdfTemplate.pixel,
          [BrandSwatch.navy, BrandSwatch.midnight, BrandSwatch.indigo],
        ),
      ],
    ),
    (
      PdfTemplateCategory.modern,
      [
        (
          PdfTemplate.slant,
          [
            BrandSwatch.royal,
            BrandSwatch.teal,
            BrandSwatch.indigo,
            BrandSwatch.coral,
          ],
        ),
        (
          PdfTemplate.capsule,
          [
            BrandSwatch.indigo,
            BrandSwatch.ocean,
            BrandSwatch.coral,
            BrandSwatch.emerald,
            BrandSwatch.violet,
          ],
        ),
        (
          PdfTemplate.pixel,
          [BrandSwatch.royal, BrandSwatch.teal, BrandSwatch.violet],
        ),
        (
          PdfTemplate.fold,
          [
            BrandSwatch.violet,
            BrandSwatch.indigo,
            BrandSwatch.royal,
            BrandSwatch.teal,
          ],
        ),
      ],
    ),
    (
      PdfTemplateCategory.creative,
      [
        (
          PdfTemplate.confetti,
          [
            BrandSwatch.amber,
            BrandSwatch.coral,
            BrandSwatch.rose,
            BrandSwatch.violet,
            BrandSwatch.teal,
            BrandSwatch.ocean,
          ],
        ),
        (
          PdfTemplate.swoosh,
          [BrandSwatch.violet, BrandSwatch.rose, BrandSwatch.teal],
        ),
        (
          PdfTemplate.fold,
          [BrandSwatch.rose, BrandSwatch.plum, BrandSwatch.coral],
        ),
        (PdfTemplate.capsule, [BrandSwatch.rose, BrandSwatch.plum]),
      ],
    ),
    (
      PdfTemplateCategory.elegant,
      [
        (
          PdfTemplate.silk,
          [
            BrandSwatch.midnight,
            BrandSwatch.wine,
            BrandSwatch.forest,
            BrandSwatch.navy,
            BrandSwatch.bronze,
          ],
        ),
        (
          PdfTemplate.pearl,
          [
            BrandSwatch.rose,
            BrandSwatch.wine,
            BrandSwatch.plum,
            BrandSwatch.bronze,
            BrandSwatch.navy,
          ],
        ),
        (
          PdfTemplate.linea,
          [BrandSwatch.wine, BrandSwatch.forest, BrandSwatch.bronze],
        ),
        (PdfTemplate.plaque, [BrandSwatch.wine, BrandSwatch.plum]),
        (
          PdfTemplate.quartz,
          [BrandSwatch.midnight, BrandSwatch.forest, BrandSwatch.plum],
        ),
      ],
    ),
    (
      PdfTemplateCategory.bold,
      [
        (
          PdfTemplate.trio,
          [
            BrandSwatch.emerald,
            BrandSwatch.navy,
            BrandSwatch.crimson,
            BrandSwatch.royal,
            BrandSwatch.violet,
            BrandSwatch.coral,
          ],
        ),
        (
          PdfTemplate.silk,
          [
            BrandSwatch.crimson,
            BrandSwatch.royal,
            BrandSwatch.emerald,
            BrandSwatch.coral,
          ],
        ),
        (
          PdfTemplate.plaque,
          [BrandSwatch.crimson, BrandSwatch.royal, BrandSwatch.emerald],
        ),
        (
          PdfTemplate.pixel,
          [BrandSwatch.crimson, BrandSwatch.emerald, BrandSwatch.charcoal],
        ),
        (PdfTemplate.slant, [BrandSwatch.crimson, BrandSwatch.amber]),
      ],
    ),
  ];
}
