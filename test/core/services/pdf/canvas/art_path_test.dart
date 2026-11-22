import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/services/pdf/canvas/art_path.dart';
import 'package:receipt_maker/core/services/pdf/canvas/art_shape.dart';
import 'package:receipt_maker/core/services/pdf/canvas/canvas_designs.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template.dart';

void main() {
  test('paths split into absolute steps', () {
    final steps = ArtPath.parse('M0 0 L10.5 -2 C1 2 3 4 5 6 Z');
    expect(steps.map((s) => s.command), ['M', 'L', 'C', 'Z']);
    expect(steps[1].values, [10.5, -2]);
    expect(steps[2].values, hasLength(6));
  });

  test('every art path uses only what the app previews can draw', () {
    final allowed = {'M', 'L', 'C', 'Q', 'Z'};
    const counts = {'M': 2, 'L': 2, 'C': 6, 'Q': 4, 'Z': 0};
    for (final t in PdfTemplate.values) {
      final design = CanvasDesigns.of(t);
      if (design == null) continue;
      expect(design.shapes, isNotEmpty, reason: t.id);
      for (final ArtShape shape in design.allShapes) {
        final d = shape.d;
        if (d == null) continue;
        expect(
          RegExp('[A-Za-z]').allMatches(d).map((m) => m.group(0)),
          everyElement(isIn(allowed)),
          reason: t.id,
        );
        for (final step in ArtPath.parse(d)) {
          expect(step.values.length, counts[step.command], reason: t.id);
        }
      }
    }
  });

  test('twenty-nine layouts are full-page art designs', () {
    final canvas = PdfTemplate.values.where((t) => CanvasDesigns.of(t) != null);
    expect(canvas, hasLength(29));
    expect(canvas.every((t) => t.requiresPro), isTrue);
  });
}
