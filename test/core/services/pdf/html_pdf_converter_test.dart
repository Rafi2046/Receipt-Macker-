import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/services/pdf/html_pdf_converter.dart';
import 'package:receipt_maker/core/services/pdf/pdf_page_size.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel(HtmlPdfConverter.channelName);
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('sends html, path and page size; returns the page count', () async {
    MethodCall? seen;
    messenger.setMockMethodCallHandler(channel, (call) async {
      seen = call;
      return 3;
    });
    final pages = await HtmlPdfConverter().toPdf(
      html: '<p>x</p>',
      path: '/tmp/a.pdf',
      size: PdfPageSize.letter,
    );
    expect(pages, 3);
    expect(seen?.method, 'htmlToPdf');
    expect(seen?.arguments, {
      'html': '<p>x</p>',
      'path': '/tmp/a.pdf',
      'pageSize': 'letter',
    });
  });

  test('runs one job at a time, even after a failure', () async {
    final order = <String>[];
    var calls = 0;
    messenger.setMockMethodCallHandler(channel, (call) async {
      final n = ++calls;
      order.add('start $n');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      order.add('end $n');
      if (n == 1) throw PlatformException(code: 'pdf');
      return 1;
    });
    final converter = HtmlPdfConverter();
    final first = converter.toPdf(html: 'a', path: 'a');
    final second = converter.toPdf(html: 'b', path: 'b');
    await expectLater(first, throwsA(isA<PlatformException>()));
    expect(await second, 1);
    expect(order, ['start 1', 'end 1', 'start 2', 'end 2']);
  });
}
