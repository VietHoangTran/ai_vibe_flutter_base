import 'package:flutter/material.dart';

import '../../../../core/localization/supported_locales.dart';
import '../../domain/entities/app_settings.dart';

/// Data-layer representation of [AppSettings] persisted as primitives.
///
/// Settings are stored locally as simple strings (no JSON/remote payload), so
/// this model maps those raw values to and from the domain entity.
class SettingsModel {
  const SettingsModel({this.themeMode, this.languageCode});

  /// Stored `ThemeMode.name` (e.g. `system`, `light`, `dark`).
  final String? themeMode;

  /// Stored locale language code (e.g. `en`). Null means follow the system.
  final String? languageCode;

  AppSettings toEntity() {
    return AppSettings(
      themeMode: _parseThemeMode(themeMode),
      locale: localeFromLanguageCode(languageCode),
    );
  }

  static ThemeMode _parseThemeMode(String? value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
