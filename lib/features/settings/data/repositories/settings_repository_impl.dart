import 'package:flutter/material.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<AppSettings> getSettings() async {
    final model = await _localDataSource.read();
    return model.toEntity();
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) =>
      _localDataSource.writeThemeMode(mode.name);

  @override
  Future<void> saveLocale(Locale? locale) =>
      _localDataSource.writeLocale(locale?.languageCode);
}
