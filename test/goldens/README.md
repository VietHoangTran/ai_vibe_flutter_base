# Golden Tests

Golden tests pin the rendered pixels of design-critical screens/widgets so
unintended visual drift fails CI.

## Layout

```text
test/goldens/
├── <screen>_test.dart        # golden test files
├── images/                   # generated goldens (committed)
└── reference/                # design screenshots from Figma (committed)
```

`reference/` holds the Figma screenshot a screen was built from (saved by the
`/figma-screen` workflow). It is not used by the test runner — it exists so a
reviewer can diff `images/<screen>.png` against `reference/<screen>.png`.

## Writing one

```dart
testWidgets('login page golden', (tester) async {
  await tester.binding.setSurfaceSize(const Size(390, 844)); // iPhone-ish
  await tester.pumpWidget(/* ProviderScope + MaterialApp(theme: AppTheme.light) + page */);
  await tester.pumpAndSettle();

  await expectLater(
    find.byType(LoginPage),
    matchesGoldenFile('images/login_page.png'),
  );
});
```

Conventions:

- Fix the surface size (default 390x844) so goldens are deterministic.
- Pump with the real `AppTheme.light` (and `.dark` when the screen matters in
  both) plus localization delegates, overriding providers with fakes.
- Name files `images/<page>_<state>[.dark].png`.

## Updating

Only after visually confirming the diff is intentional:

```bash
flutter test --update-goldens test/goldens
```

Never run `--update-goldens` to silence a failure you have not looked at.

## Caveat

Font rendering differs across platforms; goldens generated on macOS may not
match Linux CI byte-for-byte. If that bites, generate goldens in CI's
environment or scope golden assertions to layout-heavy widgets. Flutter's
default test font (Ahem) keeps most cases stable.
