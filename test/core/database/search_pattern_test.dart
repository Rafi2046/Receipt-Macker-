import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/database/search_pattern.dart';

void main() {
  test('wraps the query and escapes LIKE wildcards', () {
    expect(SearchPattern.contains('abc'), '%abc%');
    expect(SearchPattern.contains('50%'), r'%50\%%');
    expect(SearchPattern.contains('a_b'), r'%a\_b%');
    expect(SearchPattern.contains(r'a\b'), r'%a\\b%');
  });
}
