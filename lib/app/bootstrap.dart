import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import '../core/utils/app_logger.dart';

Future<void> bootstrap() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      FlutterError.onError = (details) {
        AppLogger.instance.e(
          'Flutter framework error',
          error: details.exception,
          stackTrace: details.stack,
        );
      };

      runApp(const ProviderScope(child: App()));
    },
    (Object error, StackTrace stackTrace) {
      AppLogger.instance.e(
        'Uncaught zone error',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}
