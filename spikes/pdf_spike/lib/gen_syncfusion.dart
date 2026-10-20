import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'spike_data.dart';

/// Candidate B: syncfusion_flutter_pdf. It has no font fallback, so it uses
/// a merged Latin+Bengali Noto font (spike-only) to give it a fair test.
Future<Uint8List> buildWithSyncfusion() async {
  final regular = (await rootBundle.load('assets/fonts/NotoMerged-Regular.ttf')).buffer.asUint8List();
  final bold = (await rootBundle.load('assets/fonts/NotoMerged-Bold.ttf')).buffer.asUint8List();
  PdfFont f(double size, {bool b = false}) => PdfTrueTypeFont(b ? bold : regular, size);

  final doc = PdfDocument();
  doc.pageSettings
    ..size = PdfPageSize.a4
    ..margins.all = 36;
  var page = doc.pages.add();
  final width = page.getClientSize().width;
  var y = 0.0;
  final layout = PdfLayoutFormat(layoutType: PdfLayoutType.paginate);

  void text(String s, PdfFont font) {
    final result = PdfTextElement(text: s, font: font).draw(
      page: page,
      bounds: Rect.fromLTWH(0, y, width, 0),
      format: layout,
    );
    if (result == null) return;
    page = result.page;
    y = result.bounds.bottom + 6;
  }

  text('B · syncfusion_flutter_pdf', f(9));
  text(SpikeData.title, f(22, b: true));
  text(SpikeData.conjuncts, f(26));
  text(SpikeData.conjunctWords, f(14));
  text(SpikeData.vowelSigns, f(14));
  text(SpikeData.digits, f(11));
  text(SpikeData.taka, f(11, b: true));
  text(SpikeData.mixed, f(11));
  text(SpikeData.paragraph, f(10));

  final grid = PdfGrid()..repeatHeader = true;
  grid.columns.add(count: 5);
  grid.headers.add(1);
  final header = grid.headers[0];
  for (var i = 0; i < 5; i++) {
    header.cells[i].value = SpikeData.headers[i];
  }
  header.style.font = f(10, b: true);
  for (final r in SpikeData.rows()) {
    final row = grid.rows.add();
    for (var i = 0; i < 5; i++) {
      row.cells[i].value = r[i];
    }
  }
  grid.style.font = f(9.5);
  grid.columns[0].width = 24;
  grid.columns[2].width = 32;
  grid.draw(page: page, bounds: Rect.fromLTWH(0, y, width, 0), format: layout);

  final bytes = Uint8List.fromList(await doc.save());
  doc.dispose();
  return bytes;
}
