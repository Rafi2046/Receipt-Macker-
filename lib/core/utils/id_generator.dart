import 'dart:math';

/// Random 128-bit ids as 32 hex characters. Ids never encode personal data.
abstract final class IdGenerator {
  static final Random _random = Random.secure();
  static const int _bytes = 16;
  static const int _byteRange = 256;
  static const int _radix = 16;

  static String next() => List.generate(
    _bytes,
    (_) => _random.nextInt(_byteRange).toRadixString(_radix).padLeft(2, '0'),
  ).join();
}
