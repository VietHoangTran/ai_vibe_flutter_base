import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Immutable app-wide preferences owned by the settings feature.
///
/// A null [locale] means "follow the system language".
class AppSettings extends Equatable {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.locale,
  });

  final ThemeMode themeMode;
  final Locale? locale;

  AppSettings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool clearLocale = false,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: clearLocale ? null : (locale ?? this.locale),
    );
  }

  @override
  List<Object?> get props => [themeMode, locale];
}
