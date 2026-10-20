import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'widget_gallery_state.dart';

part 'widget_gallery_view_model.g.dart';

/// Demo state for the widget gallery, so inputs show real round-trips.
@riverpod
class WidgetGalleryViewModel extends _$WidgetGalleryViewModel {
  static const List<String> currencies = ['BDT', 'USD', 'INR', 'JPY'];

  @override
  WidgetGalleryState build() => const WidgetGalleryState();

  void setClientName(String value) => state = state.copyWith(clientName: value);

  void setAmount(int? minor) => state = state.copyWith(amountMinor: minor);

  void setDueDate(DateTime date) => state = state.copyWith(dueDate: date);

  void setCurrency(String code) => state = state.copyWith(currencyCode: code);

  void toggleSaving() => state = state.copyWith(isSaving: !state.isSaving);
}
