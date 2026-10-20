import '../../../l10n/gen/app_localizations.dart';
import '../../errors/failure.dart';

/// Localized, actionable message for any error that reaches the UI.
extension FailureMessageX on AppLocalizations {
  String messageFor(Object? error) => switch (error) {
    DatabaseFailure() => errorDatabase,
    StorageFailure() => errorStorage,
    NotFoundFailure() => errorNotFound,
    PdfFailure() => errorPdf,
    ValidationFailure() => errorValidation,
    _ => errorGeneric,
  };
}
