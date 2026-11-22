import '../pdf_template.dart';
import 'canvas_arts_bold.dart';
import 'canvas_arts_brand.dart';
import 'canvas_arts_card.dart';
import 'canvas_arts_clean.dart';
import 'canvas_arts_light.dart';
import 'canvas_design.dart';

/// Which layouts are full-page art designs, and their art.
abstract final class CanvasDesigns {
  /// The art of [template], or null when it is a plain HTML layout.
  static CanvasDesign? of(PdfTemplate template) => switch (template) {
    PdfTemplate.wave => CanvasArtsLight.wave,
    PdfTemplate.mesh => CanvasArtsLight.mesh,
    PdfTemplate.corner => CanvasArtsLight.corner,
    PdfTemplate.bubble => CanvasArtsLight.bubble,
    PdfTemplate.hive => CanvasArtsLight.hive,
    PdfTemplate.tide => CanvasArtsLight.tide,
    PdfTemplate.halftone => CanvasArtsLight.halftone,
    PdfTemplate.frame => CanvasArtsLight.frame,
    PdfTemplate.lattice => CanvasArtsLight.lattice,
    PdfTemplate.prism => CanvasArtsBold.prism,
    PdfTemplate.sash => CanvasArtsBold.sash,
    PdfTemplate.peak => CanvasArtsBold.peak,
    PdfTemplate.shard => CanvasArtsBold.shard,
    PdfTemplate.nocturne => CanvasArtsBold.nocturne,
    PdfTemplate.dusk => CanvasArtsBold.dusk,
    PdfTemplate.carbon => CanvasArtsBold.carbon,
    PdfTemplate.swoosh => CanvasArtsBrand.swoosh,
    PdfTemplate.slant => CanvasArtsBrand.slant,
    PdfTemplate.capsule => CanvasArtsBrand.capsule,
    PdfTemplate.pixel => CanvasArtsBrand.pixel,
    PdfTemplate.silk => CanvasArtsBrand.silk,
    PdfTemplate.confetti => CanvasArtsBrand.confetti,
    PdfTemplate.plaque => CanvasArtsCard.plaque,
    PdfTemplate.trio => CanvasArtsCard.trio,
    PdfTemplate.fold => CanvasArtsCard.fold,
    PdfTemplate.linea => CanvasArtsClean.linea,
    PdfTemplate.margin => CanvasArtsClean.margin,
    PdfTemplate.quartz => CanvasArtsClean.quartz,
    PdfTemplate.pearl => CanvasArtsClean.pearl,
    _ => null,
  };
}
