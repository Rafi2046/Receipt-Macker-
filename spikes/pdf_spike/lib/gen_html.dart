import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'spike_data.dart';

const _channel = MethodChannel('spike/html2pdf');

/// Candidate C: HTML/CSS printed to PDF by the Android WebView (Chromium,
/// HarfBuzz shaping) through a small native bridge (MainActivity.kt).
/// `Printing.convertHtml` was tried first: deprecated and hangs on Android 14.
Future<Uint8List> buildWithHtml() => _build(embedFonts: true);

/// Same, relying on the system fonts (Android ships Noto Sans Bengali).
Future<Uint8List> buildWithHtmlSystemFonts() => _build(embedFonts: false);

Future<Uint8List> _build({required bool embedFonts}) async {
  Future<String> face(String family, String file, int weight) async {
    final b64 = base64Encode((await rootBundle.load('assets/fonts/$file')).buffer.asUint8List());
    return "@font-face{font-family:'$family';font-weight:$weight;src:url(data:font/ttf;base64,$b64) format('truetype');}";
  }

  final fonts = !embedFonts ? '' : [
    await face('SpikeLatin', 'NotoSans-Regular.ttf', 400),
    await face('SpikeLatin', 'NotoSans-Bold.ttf', 700),
    await face('SpikeBengali', 'NotoSansBengali-Regular.ttf', 400),
    await face('SpikeBengali', 'NotoSansBengali-Bold.ttf', 700),
  ].join();
  const esc = HtmlEscape();
  final rows = SpikeData.rows()
      .map((r) => '<tr>${r.indexed.map((c) => '<td class="c${c.$1}">${esc.convert(c.$2)}</td>').join()}</tr>')
      .join();
  final html = '''
<!doctype html><html><head><meta charset="utf-8"><style>
$fonts
@page{size:A4;margin:36pt}
body{font-family:'SpikeLatin','SpikeBengali',sans-serif;font-size:11pt;margin:0;color:#111}
p{margin:0 0 6pt 0}
table{width:100%;border-collapse:collapse;font-size:9.5pt}
thead{display:table-header-group} tr{break-inside:avoid}
th{font-weight:700;font-size:10pt;text-align:left;border-bottom:1.5pt solid #333;padding:4pt}
td{border-bottom:.5pt solid #bbb;padding:4pt}
.c0,.c2{text-align:center;width:24pt} .c3,.c4{text-align:right;white-space:nowrap}
</style></head><body>
<p style="font-size:9pt">C · HTML → PDF (Android WebView) · ${embedFonts ? "embedded fonts" : "system fonts"}</p>
<p style="font-size:22pt;font-weight:700">${SpikeData.title}</p>
<p style="font-size:26pt">${SpikeData.conjuncts}</p>
<p style="font-size:14pt">${SpikeData.conjunctWords}</p>
<p style="font-size:14pt">${SpikeData.vowelSigns}</p>
<p>${SpikeData.digits}</p>
<p style="font-weight:700">${SpikeData.taka}</p>
<p>${esc.convert(SpikeData.mixed)}</p>
<p style="font-size:10pt">${SpikeData.paragraph}</p>
<table><thead><tr>${SpikeData.headers.map((h) => '<th>${esc.convert(h)}</th>').join()}</tr></thead><tbody>$rows</tbody></table>
</body></html>''';
  final bytes = await _channel.invokeMethod<Uint8List>('convert', {'html': html});
  return bytes ?? (throw StateError('no bytes'));
}
