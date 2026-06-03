import 'package:ai_vibe_flutter_base/features/settings/domain/repositories/settings_repository.dart';
import 'package:ai_vibe_flutter_base/features/settings/domain/usecases/update_locale_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Locale('en'));
  });

  test('saves a supported locale through the repository', () async {
    final repository = _MockSettingsRepository();
    when(() => repository.saveLocale(any())).thenAnswer((_) async {});

    await UpdateLocaleUseCase(repository)(const Locale('vi'));

    verify(() => repository.saveLocale(const Locale('vi'))).called(1);
  });

  test('clears the locale override when given null', () async {
    final repository = _MockSettingsRepository();
    when(() => repository.saveLocale(null)).thenAnswer((_) async {});

    await UpdateLocaleUseCase(repository)(null);

    verify(() => repository.saveLocale(null)).called(1);
  });

  test('throws on an unsupported locale and does not persist', () async {
    final repository = _MockSettingsRepository();

    expect(
      () => UpdateLocaleUseCase(repository)(const Locale('fr')),
      throwsArgumentError,
    );
    verifyNever(() => repository.saveLocale(any()));
  });
}
