import 'package:flutter/material.dart';
import 'package:ai_vibe_flutter_base/core/localization/localization_provider.dart';
import 'package:ai_vibe_flutter_base/core/storage/shared_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('LocaleController stores selected locale', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) async => prefs),
      ],
    );
    addTearDown(container.dispose);

    await container.read(localeControllerProvider.notifier).setLocale(const Locale('vi'));

    expect(container.read(localeControllerProvider), const Locale('vi'));
    expect(prefs.getString(LocaleController.storageKey), 'vi');
  });
}
