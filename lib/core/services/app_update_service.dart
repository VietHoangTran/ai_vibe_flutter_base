import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upgrader/upgrader.dart';

final appUpdateServiceProvider = Provider<AppUpdateService>(
  (ref) => const AppUpdateService(),
);

class AppUpdateService {
  const AppUpdateService();

  Widget wrapWithUpgradeAlert({required Widget child}) {
    return UpgradeAlert(child: child);
  }
}
