import 'package:ai_vibe_flutter_base/core/localization/l10n/app_localizations.dart';
import 'package:ai_vibe_flutter_base/core/routing/app_router.dart';
import 'package:ai_vibe_flutter_base/core/storage/shared_preferences_provider.dart';
import 'package:ai_vibe_flutter_base/features/auth/data/repositories/auth_repository_provider.dart';
import 'package:ai_vibe_flutter_base/features/auth/domain/entities/app_user.dart';
import 'package:ai_vibe_flutter_base/features/auth/domain/repositories/auth_repository.dart';
import 'package:ai_vibe_flutter_base/features/auth/presentation/pages/home_page.dart';
import 'package:ai_vibe_flutter_base/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

/// Mirrors `App`: watches the router provider so a rebuilt GoRouter (after the
/// auth state resolves) is picked up, just like the real app.
class _RouterHarness extends ConsumerWidget {
  const _RouterHarness();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}

void main() {
  late SharedPreferences prefs;
  late _MockAuthRepository authRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    authRepository = _MockAuthRepository();
  });

  Future<void> pumpRouter(WidgetTester tester) async {
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
        child: const _RouterHarness(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('redirects to the login page when unauthenticated', (
    tester,
  ) async {
    when(authRepository.currentUser).thenAnswer((_) async => null);

    await pumpRouter(tester);

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  testWidgets('shows the home page when authenticated', (tester) async {
    when(authRepository.currentUser).thenAnswer(
      (_) async =>
          const AppUser(id: '1', email: 'demo@example.com', name: 'Demo'),
    );

    await pumpRouter(tester);

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
  });
}
