import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upgrader/upgrader.dart';

/// Wraps the app with `upgrader`'s store-version check.
///
/// Wired in `App` via `MaterialApp.router`'s builder. The alert only fires
/// for apps actually published on a store, so it is a silent no-op for this
/// base. Override [appUpdateServiceProvider] in tests (or to customise
/// `Upgrader` behaviour such as minimum days between alerts).
final appUpdateServiceProvider = Provider<AppUpdateService>(
  (ref) => const AppUpdateService(),
);

class AppUpdateService {
  const AppUpdateService();

  Widget wrapWithUpgradeAlert({
    required Widget child,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    return UpgradeAlert(navigatorKey: navigatorKey, child: child);
  }
}
