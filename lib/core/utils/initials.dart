import 'package:flutter/widgets.dart' show StringCharacters;

/// Up to two initials from a display name, one per word.
///
/// Works on grapheme clusters, so a Bangla name keeps a whole letter with its
/// vowel sign or conjunct (e.g. "রহিম উদ্দিন" gives "রউ", "ক্ষমা" gives "ক্ষ").
abstract final class Initials {
  static String of(String name, {int max = 2}) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final letters = words.take(max).map(_firstLetter);
    return letters.join().toUpperCase();
  }

  static String _firstLetter(String word) {
    final chars = word.characters;
    final first = chars.first;
    // A Bangla consonant followed by hasant forms a conjunct with the next letter.
    if (chars.length > 1 && first.endsWith('্')) return chars.take(2).join();
    return first;
  }
}
