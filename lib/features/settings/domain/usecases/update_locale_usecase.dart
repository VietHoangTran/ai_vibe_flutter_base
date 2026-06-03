import 'package:flutter/material.dart';

import '../../../../core/localization/supported_locales.dart';
import '../repositories/settings_repository.dart';

class UpdateLocaleUseCase {
  const UpdateLocaleUseCase(this._repository);

  final SettingsRepository _repository;

  /// Persists the selected [locale]. Pass null to follow the system language.
  ///
  /// Throws [ArgumentError] when given an unsupported locale.
  Future<void> call(Locale? locale) {
    if (locale != null && !isSupportedLocale(locale)) {
      throw ArgumentError.value(locale, 'locale', 'Unsupported locale');
    }
    return _repository.saveLocale(locale);
  }
}
