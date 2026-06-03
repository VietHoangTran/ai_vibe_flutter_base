import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/app_exception.dart';
import '../models/settings_model.dart';

/// Reads and writes settings primitives in [SharedPreferences].
class SettingsLocalDataSource {
  const SettingsLocalDataSource(this._prefs);

  static const themeModeKey = 'app_theme_mode';
  static const localeKey = 'app_locale';

  final Future<SharedPreferences> _prefs;

  Future<SettingsModel> read() async {
    try {
      final prefs = await _prefs;
      return SettingsModel(
        themeMode: prefs.getString(themeModeKey),
        languageCode: prefs.getString(localeKey),
      );
    } catch (error) {
      throw StorageException('Could not read settings', cause: error);
    }
  }

  Future<void> writeThemeMode(String value) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(themeModeKey, value);
    } catch (error) {
      throw StorageException('Could not save theme mode', cause: error);
    }
  }

  Future<void> writeLocale(String? languageCode) async {
    try {
      final prefs = await _prefs;
      if (languageCode == null) {
        await prefs.remove(localeKey);
      } else {
        await prefs.setString(localeKey, languageCode);
      }
    } catch (error) {
      throw StorageException('Could not save locale', cause: error);
    }
  }
}
