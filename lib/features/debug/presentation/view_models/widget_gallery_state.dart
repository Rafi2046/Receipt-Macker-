import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_gallery_state.freezed.dart';

@freezed
abstract class WidgetGalleryState with _$WidgetGalleryState {
  const factory WidgetGalleryState({
    @Default('') String clientName,
    int? amountMinor,
    DateTime? dueDate,
    @Default('BDT') String currencyCode,
    @Default(false) bool isSaving,
  }) = _WidgetGalleryState;

  const WidgetGalleryState._();

  bool get isNameMissing => clientName.trim().isEmpty;
}
