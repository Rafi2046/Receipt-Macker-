import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/models/quote.dart';

part 'quote_editor_state.freezed.dart';

@freezed
abstract class QuoteEditorState with _$QuoteEditorState {
  const factory QuoteEditorState({
    required Quote draft,
    required Quote initial,
    required bool isNew,
    @Default(false) bool isSaving,
    @Default(false) bool isConverting,
    Failure? failure,
  }) = _QuoteEditorState;

  const QuoteEditorState._();

  bool get hasUnsavedChanges => draft != initial;

  bool get isBusy => isSaving || isConverting;
}
