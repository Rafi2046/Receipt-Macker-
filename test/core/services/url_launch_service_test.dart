import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/services/url_launch_service.dart';

void main() {
  group('UrlLaunchService', () {
    test('empty phone returns false without throwing', () async {
      expect(await UrlLaunchService.callPhone(''), isFalse);
      expect(await UrlLaunchService.callPhone('   '), isFalse);
      expect(await UrlLaunchService.openWhatsApp(''), isFalse);
      expect(await UrlLaunchService.openWhatsApp('   '), isFalse);
    });

    test('invalid phone without digits returns false', () async {
      expect(await UrlLaunchService.callPhone('---'), isFalse);
      expect(await UrlLaunchService.openWhatsApp('---'), isFalse);
    });
  });
}
