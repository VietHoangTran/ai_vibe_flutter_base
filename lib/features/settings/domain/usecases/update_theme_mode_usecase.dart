import 'package:flutter/material.dart';

import '../repositories/settings_repository.dart';

class UpdateThemeModeUseCase {
  const UpdateThemeModeUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(ThemeMode mode) => _repository.saveThemeMode(mode);
}
