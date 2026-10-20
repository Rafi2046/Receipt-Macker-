import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import 'gen_html.dart';
import 'gen_pdf_pkg.dart';
import 'gen_syncfusion.dart';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: SpikeHome()));

typedef Builder = Future<Uint8List> Function();

const candidates = <(String, String, Builder)>[
  ('a_pdf', 'A · package:pdf', buildWithPdfPackage),
  ('b_syncfusion', 'B · syncfusion_flutter_pdf', buildWithSyncfusion),
  ('c_html', 'C · HTML → PDF (WebView)', buildWithHtml),
  ('c2_html_sys', 'C2 · HTML, system fonts', buildWithHtmlSystemFonts),
];

class SpikeHome extends StatelessWidget {
  const SpikeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF spike')),
      body: ListView(
        children: [
          for (final (id, label, build) in candidates)
            ListTile(
              title: Text(label),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => SpikeViewer(id: id, label: label, build: build)),
              ),
            ),
        ],
      ),
    );
  }
}

/// Generates the PDF, saves it, and renders its pages with the phone's own
/// PDF renderer (Android PdfRenderer via Printing.raster).
class SpikeViewer extends StatefulWidget {
  const SpikeViewer({required this.id, required this.label, required this.build, super.key});

  final String id;
  final String label;
  final Builder build;

  @override
  State<SpikeViewer> createState() => _SpikeViewerState();
}

class _SpikeViewerState extends State<SpikeViewer> {
  final _pages = <Uint8List>[];
  String _info = 'Generating…';

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    try {
      final sw = Stopwatch()..start();
      final bytes = await widget.build().timeout(const Duration(seconds: 60));
      final ms = sw.elapsedMilliseconds;
      final dir = await getApplicationDocumentsDirectory();
      await File('${dir.path}/${widget.id}.pdf').writeAsBytes(bytes);
      await for (final page in Printing.raster(bytes, dpi: 130)) {
        _pages.add(await page.toPng());
      }
      setState(() => _info = '${(bytes.length / 1024).toStringAsFixed(0)} KB · ${_pages.length} pages · $ms ms');
    } on Object catch (e) {
      setState(() => _info = 'ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(title: Text(widget.label), bottom: PreferredSize(
        preferredSize: const Size.fromHeight(24),
        child: Text(_info),
      )),
      body: ListView.separated(
        itemCount: _pages.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (_, i) => Image.memory(_pages[i], fit: BoxFit.fitWidth),
      ),
    );
  }
}
