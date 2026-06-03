import 'package:flutter/material.dart';

void showAppSnackBar(
  BuildContext context, {
  required String message,
  AppSnackBarType type = AppSnackBarType.info,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final backgroundColor = switch (type) {
    AppSnackBarType.info => colorScheme.inverseSurface,
    AppSnackBarType.success => Colors.green.shade700,
    AppSnackBarType.warning => Colors.orange.shade800,
    AppSnackBarType.error => colorScheme.error,
  };

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ),
  );
}

enum AppSnackBarType { info, success, warning, error }
