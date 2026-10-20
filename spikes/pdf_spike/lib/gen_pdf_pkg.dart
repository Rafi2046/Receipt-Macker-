import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'spike_data.dart';

/// Candidate A: package:pdf (Dart PDF writer, used by `printing`).
Future<Uint8List> buildWithPdfPackage() async {
  Future<pw.Font> font(String f) async => pw.Font.ttf(await rootBundle.load('assets/fonts/$f'));
  final bnRegular = await font('NotoSansBengali-Regular.ttf');
  final bnBold = await font('NotoSansBengali-Bold.ttf');
  final theme = pw.ThemeData.withFont(
    base: await font('NotoSans-Regular.ttf'),
    bold: await font('NotoSans-Bold.ttf'),
    fontFallback: [bnRegular, bnBold],
  );
  final doc = pw.Document(theme: theme);
  pw.Widget t(String s, {double size = 11, bool bold = false}) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Text(s, style: pw.TextStyle(fontSize: size, fontWeight: bold ? pw.FontWeight.bold : null)),
  );
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      footer: (c) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text('Page ${c.pageNumber} / ${c.pagesCount} · পৃষ্ঠা', style: const pw.TextStyle(fontSize: 9)),
      ),
      build: (c) => [
        t('A · package:pdf', size: 9),
        t(SpikeData.title, size: 22, bold: true),
        t(SpikeData.conjuncts, size: 26),
        t(SpikeData.conjunctWords, size: 14),
        t(SpikeData.vowelSigns, size: 14),
        t(SpikeData.digits),
        t(SpikeData.taka, bold: true),
        t(SpikeData.mixed),
        pw.Paragraph(text: SpikeData.paragraph, style: const pw.TextStyle(fontSize: 10)),
        pw.TableHelper.fromTextArray(
          headers: SpikeData.headers,
          data: SpikeData.rows(),
          cellStyle: const pw.TextStyle(fontSize: 9.5),
          headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          cellAlignments: {0: pw.Alignment.center, 2: pw.Alignment.center, 3: pw.Alignment.centerRight, 4: pw.Alignment.centerRight},
          columnWidths: {0: const pw.FixedColumnWidth(24), 1: const pw.FlexColumnWidth(4), 2: const pw.FixedColumnWidth(32)},
        ),
      ],
    ),
  );
  return doc.save();
}
