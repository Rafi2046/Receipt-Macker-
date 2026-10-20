import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/errors/failure.dart';

/// Riverpod retries failed providers by default. A [Failure] (e.g. a record
/// that no longer exists) is shown with a Retry button instead, so it is
/// never retried in the background; other errors keep the default policy.
Duration? appProviderRetry(int retryCount, Object error) =>
    error is Failure ? null : ProviderContainer.defaultRetry(retryCount, error);
