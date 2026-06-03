import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/settings_repository_provider.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_locale_usecase.dart';
import '../../domain/usecases/update_theme_mode_usecase.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  Future<AppSettings> build() {
    final useCase = GetSettingsUseCase(ref.watch(settingsRepositoryProvider));
    return useCase();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    final useCase = UpdateThemeModeUseCase(
      ref.read(settingsRepositoryProvider),
    );
    await useCase(mode);
    final current = state.value ?? const AppSettings();
    state = AsyncData(current.copyWith(themeMode: mode));
  }

  Future<void> updateLocale(Locale? locale) async {
    final useCase = UpdateLocaleUseCase(ref.read(settingsRepositoryProvider));
    await useCase(locale);
    final current = state.value ?? const AppSettings();
    state = AsyncData(
      current.copyWith(locale: locale, clearLocale: locale == null),
    );
  }
}
