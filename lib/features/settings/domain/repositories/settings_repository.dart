import 'package:flutter/material.dart';

import '../entities/app_settings.dart';

abstract interface class SettingsRepository {
  /// Loads the persisted settings, falling back to defaults.
  Future<AppSettings> getSettings();

  Future<void> saveThemeMode(ThemeMode mode);

  /// Persists the preferred locale. A null [locale] clears the override so the
  /// app follows the system language.
  Future<void> saveLocale(Locale? locale);
}
