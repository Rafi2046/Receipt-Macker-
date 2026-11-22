import 'dart:math' as math;
import 'dart:typed_data';

/// Pure color math on `#RRGGBB` strings: parsing, HSL, mixing and picking
/// the main color of an image's pixels. No Flutter, so it is unit tested.
abstract final class HexColor {
  static final RegExp _hex = RegExp(r'^[0-9a-fA-F]+$');

  /// `#RRGGBB` (upper case) from `abc`, `#abc`, `aabbcc` or `#aabbcc`;
  /// null when [input] is not a color.
  static String? normalize(String input) {
    var clean = input.trim().replaceFirst('#', '');
    if (!_hex.hasMatch(clean)) return null;
    if (clean.length == 3) {
      clean = clean.split('').map((c) => '$c$c').join();
    }
    if (clean.length != 6) return null;
    return '#${clean.toUpperCase()}';
  }

  /// The 24-bit RGB value of a normalized hex, or null.
  static int? rgb(String? hex) {
    final n = normalize(hex ?? '');
    return n == null ? null : int.parse(n.substring(1), radix: 16);
  }

  static String fromRgb(int r, int g, int b) {
    int c(int v) => v.clamp(0, 255);
    final value = (c(r) << 16) | (c(g) << 8) | c(b);
    return '#${value.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  /// Hue in degrees [0, 360), saturation and lightness in [0, 1].
  static (double, double, double) toHsl(String hex) {
    final value = rgb(hex) ?? 0;
    final r = ((value >> 16) & 0xFF) / 255;
    final g = ((value >> 8) & 0xFF) / 255;
    final b = (value & 0xFF) / 255;
    final maxC = math.max(r, math.max(g, b));
    final minC = math.min(r, math.min(g, b));
    final l = (maxC + minC) / 2;
    final d = maxC - minC;
    if (d == 0) return (0, 0, l);
    final s = d / (1 - (2 * l - 1).abs());
    final double h;
    if (maxC == r) {
      h = 60 * (((g - b) / d) % 6);
    } else if (maxC == g) {
      h = 60 * ((b - r) / d + 2);
    } else {
      h = 60 * ((r - g) / d + 4);
    }
    return ((h + 360) % 360, s.clamp(0, 1), l);
  }

  static String fromHsl(double h, double s, double l) {
    final c = (1 - (2 * l - 1).abs()) * s;
    final hp = (h % 360) / 60;
    final x = c * (1 - (hp % 2 - 1).abs());
    final (r1, g1, b1) = switch (hp.floor()) {
      0 => (c, x, 0.0),
      1 => (x, c, 0.0),
      2 => (0.0, c, x),
      3 => (0.0, x, c),
      4 => (x, 0.0, c),
      _ => (c, 0.0, x),
    };
    final m = l - c / 2;
    int ch(double v) => ((v + m) * 255).round();
    return fromRgb(ch(r1), ch(g1), ch(b1));
  }

  /// [hex] moved [t] of the way toward [other] (0 keeps [hex]).
  static String mix(String hex, String other, double t) {
    final a = rgb(hex) ?? 0;
    final b = rgb(other) ?? 0;
    int ch(int shift) {
      final x = (a >> shift) & 0xFF;
      final y = (b >> shift) & 0xFF;
      return (x + (y - x) * t).round();
    }

    return fromRgb(ch(16), ch(8), ch(0));
  }

  /// The main color of RGBA [pixels], toned so it reads as an accent on
  /// white paper. Transparent, near-white, near-black and grey pixels are
  /// ignored; null when nothing colorful is left.
  static String? dominant(Uint8List pixels) {
    const buckets = 24;
    final weight = List<double>.filled(buckets, 0);
    final sums = List.generate(buckets, (_) => [0.0, 0.0, 0.0, 0.0]);
    for (var i = 0; i + 3 < pixels.length; i += 4) {
      if (pixels[i + 3] < 128) continue;
      final hex = fromRgb(pixels[i], pixels[i + 1], pixels[i + 2]);
      final (h, s, l) = toHsl(hex);
      if (s < 0.25 || l < 0.1 || l > 0.9) continue;
      final b = (h / (360 / buckets)).floor() % buckets;
      weight[b] += s;
      sums[b][0] += pixels[i] * s;
      sums[b][1] += pixels[i + 1] * s;
      sums[b][2] += pixels[i + 2] * s;
    }
    var best = -1;
    for (var b = 0; b < buckets; b++) {
      if (weight[b] > 0 && (best < 0 || weight[b] > weight[best])) best = b;
    }
    if (best < 0) return null;
    final w = weight[best];
    final avg = fromRgb(
      (sums[best][0] / w).round(),
      (sums[best][1] / w).round(),
      (sums[best][2] / w).round(),
    );
    final (h, s, l) = toHsl(avg);
    return fromHsl(h, math.max(s, 0.45), l.clamp(0.28, 0.52));
  }
}
