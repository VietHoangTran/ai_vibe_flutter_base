import 'package:ai_vibe_flutter_base/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Boot smoke test: the app starts on a real device/emulator, renders a
/// MaterialApp, and settles without throwing.
///
/// Run with a device attached:
///
/// ```bash
/// flutter test integration_test -d <device_id>
/// ```
///
/// This intentionally avoids feature-specific assertions so it stays green
/// while features evolve; add flow tests per feature next to this file.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app boots and renders the initial route', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: App()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
