part of 'invoice_editor_view_model.dart';

/// Line intents of the invoice editor, used by the line sheet.
extension InvoiceLineEditing on InvoiceEditorViewModel {
  /// Adds an empty one-off line and returns its id.
  String addBlankLine() {
    final id = IdGenerator.next();
    _edit((d) => d.withLine(LineItem(id: id, name: '')));
    return id;
  }

  void _line(String id, LineItem Function(LineItem l) change) =>
      _edit((d) => d.editLine(id, change));

  void setLineName(String id, String value) =>
      _line(id, (l) => l.copyWith(name: value));

  void setLineDescription(String id, String value) =>
      _line(id, (l) => l.copyWith(description: value));

  void setLineUnit(String id, String value) =>
      _line(id, (l) => l.copyWith(unit: value));

  /// [quantityMilli] is null while the field is empty.
  void setLineQuantity(String id, int? quantityMilli) =>
      _line(id, (l) => l.copyWith(quantityMilli: quantityMilli ?? 0));

  /// Entering a price clears the "priced in another currency" note.
  void setLinePrice(String id, int? minor) {
    _line(id, (l) => l.copyWith(unitPriceMinor: minor ?? 0));
    _patch(
      (f) => f.copyWith(
        foreignPriceLines: {
          for (final e in f.foreignPriceLines.entries)
            if (e.key != id) e.key: e.value,
        },
      ),
    );
  }

  void setLineDiscount(String id, Discount? discount) =>
      _line(id, (l) => l.copyWith(discount: discount));

  void removeLine(String id) => _edit((d) => d.withoutLine(id));

  /// Drops a line the user opened but never filled in.
  void discardLineIfBlank(String id) {
    final line = form?.draft.lines.where((l) => l.id == id).firstOrNull;
    if (line == null) return;
    if (line.name.trim().isEmpty && line.unitPriceMinor == 0) removeLine(id);
  }
}
