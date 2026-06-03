import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/shared_preferences_provider.dart';

const supportedLocales = [Locale('en'), Locale('vi'), Locale('ja')];

final localeControllerProvider = NotifierProvider<LocaleController, Locale?>(LocaleController.new);

class LocaleController extends Notifier<Locale?> {
  static const storageKey = 'app_locale';

  @override
  Locale? build() {
    final prefs = ref.watch(sharedPreferencesProvider).valueOrNull;
    final languageCode = prefs?.getString(storageKey);
    return _parseLocale(languageCode);
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);

    if (locale == null) {
      await prefs.remove(storageKey);
      state = null;
      return;
    }

    if (!supportedLocales.any((item) => item.languageCode == locale.languageCode)) {
      throw ArgumentError.value(locale, 'locale', 'Unsupported locale');
    }

    await prefs.setString(storageKey, locale.languageCode);
    state = locale;
  }

  Locale? _parseLocale(String? languageCode) {
    if (languageCode == null || languageCode.isEmpty) return null;

    for (final locale in supportedLocales) {
      if (locale.languageCode == languageCode) return locale;
    }

    return null;
  }
}
