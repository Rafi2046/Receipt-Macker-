import 'package:flutter/services.dart';

import 'pdf_page_size.dart';

/// Turns HTML into a PDF file with the Android WebView (our own native
/// bridge, see `HtmlPdfChannel.kt`). Jobs run one at a time.
class HtmlPdfConverter {
  HtmlPdfConverter({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(channelName);

  static const String channelName = 'quickbill/html_pdf';

  final MethodChannel _channel;
  Future<void> _queue = Future.value();

  /// Writes the PDF to [path] and returns its page count.
  Future<int> toPdf({
    required String html,
    required String path,
    PdfPageSize size = PdfPageSize.a4,
  }) => _serial(() async {
    final pages = await _channel.invokeMethod<int>('htmlToPdf', {
      'html': html,
      'path': path,
      'pageSize': size.name,
    });
    return pages ?? 0;
  });

  /// Fallback: opens the system print dialog, where "Save as PDF" also
  /// works, in case writing the file directly ever fails.
  Future<void> printWithSystemDialog({
    required String html,
    required String jobName,
  }) => _serial(
    () => _channel.invokeMethod<bool>('printHtml', {
      'html': html,
      'jobName': jobName,
    }),
  );

  Future<T> _serial<T>(Future<T> Function() job) {
    final run = _queue.then((_) => job());
    _queue = run.then((_) {}, onError: (_) {});
    return run;
  }
}
