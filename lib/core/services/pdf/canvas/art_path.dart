/// One drawing step of an [ArtShape] path, with absolute coordinates.
typedef ArtStep = ({String command, List<double> values});

/// Splits a path such as `M0 0 L10 0 C1 2 3 4 5 6 Z` into steps.
/// Only absolute `M`, `L`, `C`, `Q` and `Z` are used by our art.
abstract final class ArtPath {
  static final RegExp _token = RegExp(r'[MLCQZ]|-?\d+(?:\.\d+)?');

  static List<ArtStep> parse(String d) {
    final steps = <ArtStep>[];
    String? command;
    var values = <double>[];
    void flush() {
      if (command case final c?) steps.add((command: c, values: values));
    }

    for (final match in _token.allMatches(d)) {
      final token = match.group(0)!;
      final number = double.tryParse(token);
      if (number != null) {
        values.add(number);
        continue;
      }
      flush();
      command = token;
      values = <double>[];
    }
    flush();
    return steps;
  }
}
