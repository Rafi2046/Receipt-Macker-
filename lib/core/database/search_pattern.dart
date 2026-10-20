/// Builds LIKE patterns from what the user types, so `%` and `_` match
/// themselves instead of acting as wildcards.
abstract final class SearchPattern {
  static const String escapeChar = r'\';

  /// `50%` gives `%50\%%`: rows containing the text anywhere.
  static String contains(String query) {
    final escaped = query
        .replaceAll(escapeChar, '$escapeChar$escapeChar')
        .replaceAll('%', '$escapeChar%')
        .replaceAll('_', '${escapeChar}_');
    return '%$escaped%';
  }
}
