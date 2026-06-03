import 'package:flutter/widgets.dart';

/// Locales the app ships translations for.
const supportedLocales = [Locale('en'), Locale('vi'), Locale('ja')];

bool isSupportedLocale(Locale locale) {
  return supportedLocales.any(
    (item) => item.languageCode == locale.languageCode,
  );
}

/// Resolves a stored language code back to a supported [Locale], or null when
/// the code is empty/unknown (i.e. follow the system language).
Locale? localeFromLanguageCode(String? languageCode) {
  if (languageCode == null || languageCode.isEmpty) return null;
  for (final locale in supportedLocales) {
    if (locale.languageCode == languageCode) return locale;
  }
  return null;
}
