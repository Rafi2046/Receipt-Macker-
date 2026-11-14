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

    test('openUrl invokes urlLauncherOverride when provided', () async {
      String? launchedUrl;
      UrlLaunchService.urlLauncherOverride = (url) async {
        launchedUrl = url;
        return true;
      };
      addTearDown(() => UrlLaunchService.urlLauncherOverride = null);

      final result = await UrlLaunchService.openUrl('https://example.com/test');
      expect(result, isTrue);
      expect(launchedUrl, 'https://example.com/test');
    });

    test('openUrl returns false for empty or malformed URL', () async {
      expect(await UrlLaunchService.openUrl(''), isFalse);
    });
  });
}
