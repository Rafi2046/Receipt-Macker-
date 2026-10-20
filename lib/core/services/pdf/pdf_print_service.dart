import 'dart:typed_data';

import 'package:printing/printing.dart';

/// Sends a finished PDF to the system print dialog.
class PdfPrintService {
  /// Returns false when the user cancelled.
  Future<bool> print(Uint8List pdf, {required String name}) =>
      Printing.layoutPdf(onLayout: (_) async => pdf, name: name);
}
