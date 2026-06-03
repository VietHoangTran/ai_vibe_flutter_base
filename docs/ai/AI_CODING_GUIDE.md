# AI Coding Guide

This guide helps AI coding agents extend this Flutter base without drifting from the intended architecture.

## Start Here

1. Read `AGENTS.md`.
2. Inspect the existing feature closest to the task, usually `lib/features/auth/`.
3. If creating a feature, use `tools/feature_cli.dart`.
4. Keep generated code generated; do not manually edit `*.g.dart` or `*.freezed.dart`.

## Adding a Feature

```bash
dart run tools/feature_cli.dart <feature_name> --dry-run
dart run tools/feature_cli.dart <feature_name>
dart run build_runner build --delete-conflicting-outputs
```

Then:

- Fill in datasource API/storage logic.
- Replace placeholder entity/model fields.
- Add route in `lib/core/routing/app_router.dart` if needed.
- Add tests.

## Adding a Route

Use GoRouter in `lib/core/routing/app_router.dart`.

- Put route names in `lib/core/routing/route_names.dart`.
- Keep route builders thin.
- Do auth redirects in router-level redirect logic.

## Adding Text

Do not hardcode user-facing strings when the text is part of the app UI.

1. Add keys to:
   - `assets/l10n/app_en.arb`
   - `assets/l10n/app_vi.arb`
   - `assets/l10n/app_ja.arb`
2. Run:

```bash
flutter gen-l10n
```

3. Use `context.l10n.key`.

## Adding Assets

1. Put assets under `assets/images/` or another declared assets folder.
2. Run FlutterGen if assets are referenced in Dart:

```bash
dart run build_runner build --delete-conflicting-outputs
```

3. Prefer generated asset references when available.

## Adding API Calls

- Use `dioProvider`.
- Map network errors via existing network exception utilities.
- Keep DTO parsing in `data/models` or datasource layer.
- Keep domain entities free from transport-only details.

## Testing Pattern

Use `mocktail` for mocks.

Useful test categories:

- Widget tests for pages/shared widgets.
- Provider tests with `ProviderContainer`.
- Repository tests with mocked datasource/API.

## Common Mistakes to Avoid

- Do not introduce GetX/GetIt.
- Do not put API calls in widgets.
- Do not put UI logic in repositories.
- Do not commit secrets.
- Do not manually edit generated files.
- Do not make broad unrelated refactors while implementing a small task.
