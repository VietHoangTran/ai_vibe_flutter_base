import 'package:ai_vibe_flutter_base/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:ai_vibe_flutter_base/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SettingsRepositoryImpl buildRepository(SharedPreferences prefs) {
    return SettingsRepositoryImpl(
      SettingsLocalDataSource(Future.value(prefs)),
    );
  }

  test('returns defaults when nothing is stored', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final settings = await buildRepository(prefs).getSettings();

    expect(settings.themeMode, ThemeMode.system);
    expect(settings.locale, isNull);
  });

  test('reads back the persisted theme mode and locale', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repository = buildRepository(prefs);

    await repository.saveThemeMode(ThemeMode.dark);
    await repository.saveLocale(const Locale('ja'));

    final settings = await repository.getSettings();

    expect(settings.themeMode, ThemeMode.dark);
    expect(settings.locale, const Locale('ja'));
  });

  test('saving a null locale clears the stored override', () async {
    SharedPreferences.setMockInitialValues({'app_locale': 'vi'});
    final prefs = await SharedPreferences.getInstance();
    final repository = buildRepository(prefs);

    await repository.saveLocale(null);

    expect(prefs.getString('app_locale'), isNull);
    expect((await repository.getSettings()).locale, isNull);
  });
}
