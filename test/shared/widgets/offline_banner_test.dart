import 'package:ai_vibe_flutter_base/core/localization/l10n/app_localizations.dart';
import 'package:ai_vibe_flutter_base/core/network/connectivity_service.dart';
import 'package:ai_vibe_flutter_base/core/network/connectivity_status_provider.dart';
import 'package:ai_vibe_flutter_base/shared/widgets/offline_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpBanner(
  WidgetTester tester,
  ConnectivityStatus status,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        connectivityStatusProvider.overrideWith(
          (ref) => Stream.value(status),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: OfflineBanner()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the offline message when offline', (tester) async {
    await _pumpBanner(tester, ConnectivityStatus.offline);

    expect(find.text('No internet connection'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
  });

  testWidgets('renders nothing visible when online', (tester) async {
    await _pumpBanner(tester, ConnectivityStatus.online);

    expect(find.text('No internet connection'), findsNothing);
    expect(find.byIcon(Icons.cloud_off_outlined), findsNothing);
  });
}
