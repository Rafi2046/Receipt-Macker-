import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/services/pdf/brand_swatch.dart';
import 'package:receipt_maker/core/utils/hex_color.dart';

Uint8List _pixels(List<List<int>> rgba) =>
    Uint8List.fromList([for (final p in rgba) ...p]);

void main() {
  group('normalize', () {
    test('accepts short, long, with or without #', () {
      expect(HexColor.normalize('abc'), '#AABBCC');
      expect(HexColor.normalize('#1e6fd9'), '#1E6FD9');
      expect(HexColor.normalize(' 1E6FD9 '), '#1E6FD9');
    });

    test('rejects what is not a color', () {
      expect(HexColor.normalize(''), isNull);
      expect(HexColor.normalize('#12345'), isNull);
      expect(HexColor.normalize('#GGGGGG'), isNull);
    });
  });

  test('HSL round-trips within one step per channel', () {
    for (final hex in ['#FF5738', '#1E6FD9', '#2E7D32', '#7B1FA2']) {
      final (h, s, l) = HexColor.toHsl(hex);
      final back = HexColor.rgb(HexColor.fromHsl(h, s, l))!;
      final want = HexColor.rgb(hex)!;
      for (final shift in [16, 8, 0]) {
        final d = ((back >> shift) & 0xFF) - ((want >> shift) & 0xFF);
        expect(d.abs(), lessThanOrEqualTo(1), reason: hex);
      }
    }
  });

  test('mix moves toward the other color', () {
    expect(HexColor.mix('#000000', '#FFFFFF', 0), '#000000');
    expect(HexColor.mix('#000000', '#FFFFFF', 1), '#FFFFFF');
    expect(HexColor.mix('#000000', '#FFFFFF', 0.5), '#808080');
  });

  group('dominant', () {
    test('picks the main color and ignores white, black and transparent', () {
      final pixels = _pixels([
        for (var i = 0; i < 30; i++) [255, 255, 255, 255],
        for (var i = 0; i < 10; i++) [0, 0, 0, 255],
        for (var i = 0; i < 20; i++) [200, 30, 30, 0],
        for (var i = 0; i < 12; i++) [30, 90, 200, 255],
        for (var i = 0; i < 4; i++) [240, 160, 20, 255],
      ]);
      final (h, _, l) = HexColor.toHsl(HexColor.dominant(pixels)!);
      expect(h, inInclusiveRange(200, 240), reason: 'blue wins');
      expect(l, inInclusiveRange(0.28, 0.52), reason: 'readable on paper');
    });

    test('is null for a grey logo', () {
      final pixels = _pixels([
        for (var i = 0; i < 20; i++) [128, 128, 128, 255],
        for (var i = 0; i < 20; i++) [255, 255, 255, 255],
      ]);
      expect(HexColor.dominant(pixels), isNull);
    });
  });

  group('BrandSwatch with a custom color', () {
    test('presets keep their own tones', () {
      expect(BrandSwatch.isPreset(BrandSwatch.navy.hex), isTrue);
      expect(
        BrandSwatch.softFor(BrandSwatch.navy.hex),
        BrandSwatch.navy.softHex,
      );
    });

    test('a custom color gets a solid light wash and a dark shade', () {
      const custom = '#1E6FD9';
      expect(BrandSwatch.isPreset(custom), isFalse);
      final (_, _, softL) = HexColor.toHsl(BrandSwatch.softFor(custom));
      final (_, _, deepL) = HexColor.toHsl(BrandSwatch.deepFor(custom));
      expect(softL, greaterThan(0.9));
      expect(deepL, lessThan(HexColor.toHsl(custom).$3));
      expect(HexColor.normalize(BrandSwatch.softFor(custom)), isNotNull);
    });

    test('a yellow custom color pairs with dark slate, not gold', () {
      expect(BrandSwatch.pairFor('#F2C230'), BrandSwatch.coral.pairHex);
      expect(BrandSwatch.pairFor('#1E6FD9'), BrandSwatch.fallbackPairHex);
    });
  });
}
