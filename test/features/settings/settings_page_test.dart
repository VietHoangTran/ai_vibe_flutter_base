import 'package:ai_vibe_flutter_base/core/localization/l10n/app_localizations.dart';
import 'package:ai_vibe_flutter_base/core/storage/shared_preferences_provider.dart';
import 'package:ai_vibe_flutter_base/features/auth/data/repositories/auth_repository_provider.dart';
import 'package:ai_vibe_flutter_base/features/auth/domain/entities/app_user.dart';
import 'package:ai_vibe_flutter_base/features/auth/domain/repositories/auth_repository.dart';
import 'package:ai_vibe_flutter_base/features/settings/presentation/controllers/settings_controller.dart';
import 'package:ai_vibe_flutter_base/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SharedPreferences prefs;
  late _MockAuthRepository authRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    authRepository = _MockAuthRepository();
    when(authRepository.currentUser).thenAnswer(
      (_) async =>
          const AppUser(id: '1', email: 'demo@example.com', name: 'Demo'),
    );
  });

  Future<ProviderContainer> pumpSettings(WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) async => prefs),
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('renders the account email and settings sections', (
    tester,
  ) async {
    await pumpSettings(tester);

    expect(find.text('demo@example.com'), findsOneWidget);
    expect(find.text('APPEARANCE'), findsOneWidget);
    expect(find.text('LANGUAGE'), findsOneWidget);
  });

  testWidgets('tapping Dark updates and persists the theme mode', (
    tester,
  ) async {
    final container = await pumpSettings(tester);

    expect(
      container.read(settingsControllerProvider).value?.themeMode,
      ThemeMode.system,
    );

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(
      container.read(settingsControllerProvider).value?.themeMode,
      ThemeMode.dark,
    );
    expect(prefs.getString('app_theme_mode'), 'dark');
  });
}
