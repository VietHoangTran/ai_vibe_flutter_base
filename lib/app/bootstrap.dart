import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import '../core/monitoring/crash_reporter.dart';

Future<void> bootstrap() async {
  // One container shared by the app and the error handlers below, so uncaught
  // errors reach the same CrashReporter the rest of the app uses.
  final container = ProviderContainer();
  final crashReporter = container.read(crashReporterProvider);

  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        unawaited(
          crashReporter.recordError(
            details.exception,
            details.stack,
            fatal: true,
          ),
        );
      };

      runApp(
        UncontrolledProviderScope(
          container: container,
          child: const App(),
        ),
      );
    },
    (error, stackTrace) {
      unawaited(crashReporter.recordError(error, stackTrace, fatal: true));
    },
  );
}
