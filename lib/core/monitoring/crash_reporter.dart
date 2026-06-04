import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/app_logger.dart';

/// Sink for uncaught errors and breadcrumbs.
///
/// The base ships [LoggingCrashReporter], which only logs. To enable a real
/// service (Sentry, Firebase Crashlytics, ...), implement this interface and
/// override [crashReporterProvider] at the composition root. `bootstrap()`
/// routes `FlutterError.onError` and uncaught zone errors here.
abstract interface class CrashReporter {
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal,
  });

  Future<void> log(String message);
}

/// Default reporter that forwards everything to [AppLogger].
class LoggingCrashReporter implements CrashReporter {
  const LoggingCrashReporter();

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
  }) async {
    AppLogger.instance.e(
      fatal ? 'Fatal error' : 'Error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  Future<void> log(String message) async {
    AppLogger.instance.i(message);
  }
}

final crashReporterProvider = Provider<CrashReporter>((ref) {
  return const LoggingCrashReporter();
});
