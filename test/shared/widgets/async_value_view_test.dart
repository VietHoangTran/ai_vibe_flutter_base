import 'package:ai_vibe_flutter_base/core/error/app_exception.dart';
import 'package:ai_vibe_flutter_base/core/localization/l10n/app_localizations.dart';
import 'package:ai_vibe_flutter_base/shared/widgets/async_value_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester, {
  required Object error,
  VoidCallback? onRetry,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: AsyncValueView<int>(
          value: AsyncValue.error(error, StackTrace.empty),
          data: (value) => Text('$value'),
          onRetry: onRetry,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the AppException message instead of the raw error', (
    tester,
  ) async {
    await _pump(tester, error: const NetworkException('Server is down'));

    expect(find.text('Server is down'), findsOneWidget);
    expect(find.textContaining('NetworkException'), findsNothing);
  });

  testWidgets('falls back to the localized generic message', (tester) async {
    await _pump(tester, error: StateError('internal detail'));

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.textContaining('internal detail'), findsNothing);
  });

  testWidgets('shows a retry button that invokes onRetry', (tester) async {
    var retried = false;
    await _pump(
      tester,
      error: const NetworkException('Boom'),
      onRetry: () => retried = true,
    );

    await tester.tap(find.text('Retry'));
    expect(retried, isTrue);
  });

  testWidgets('hides the retry button when onRetry is not provided', (
    tester,
  ) async {
    await _pump(tester, error: const NetworkException('Boom'));

    expect(find.text('Retry'), findsNothing);
  });
}
