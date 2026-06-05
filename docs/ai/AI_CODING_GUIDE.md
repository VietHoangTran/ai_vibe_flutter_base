# AI Coding Guide

This guide helps AI coding agents extend this Flutter base without drifting from
the intended architecture.

## Start Here

1. Read `AGENTS.md`.
2. Read `docs/HARNESS.md`.
3. Read this guide.
4. Read `docs/ai/TASK_PLAYBOOK.md` for the task-specific checklist.
5. Inspect the closest existing feature pattern:
   - `lib/features/auth/` is the canonical full-layer reference feature.
   - `lib/features/settings/` is the reference for persisted preferences.
6. If creating a feature, use `tools/feature_cli.dart`.
7. Keep generated code generated; do not manually edit `*.g.dart`,
   `*.freezed.dart`, or generated localization files.

## Skills and Agents

Use the project skills when the task matches:

- `/spec` for Normal/High-risk features starting from a raw requirement.
- `/figma-screen` whenever the UI source is a Figma link.
- `/figma-tokens` before building from a new design file.
- `/run-app` for live screenshot proof.

When the harness provides them, run the `flutter-reviewer` agent after
writing code and the `dart-build-resolver` agent when builds fail. Load the
`dart-flutter-patterns` / `flutter-testing` skills for non-trivial Riverpod
or test design questions.

## Before Editing

Answer these before making changes:

1. What is the smallest useful change?
2. Is this tiny, normal, or high-risk according to `FEATURE_INTAKE.md`?
3. Which layers are affected: presentation, controller, domain, repository,
   datasource, routing, localization, native config?
4. Does user-facing text require ARB updates?
5. What command proves the change works according to `VALIDATION_MATRIX.md`?

## Adding a Feature

Run a dry-run first:

```bash
dart run tools/feature_cli.dart <feature_name> --dry-run
```

Then generate the skeleton. Add guidance flags when useful:

```bash
dart run tools/feature_cli.dart <feature_name>
dart run tools/feature_cli.dart <feature_name> --with-route --with-localization
```

Then:

- Replace generated `TODO(<feature>)` items with real logic.
- Fill in datasource API/storage logic.
- Replace placeholder entity/model fields.
- If you passed `--with-route`, verify the auto-registered route at the
  `// feature_cli:` anchors; otherwise add the route in
  `lib/core/routing/app_router.dart` manually.
- Add all user-facing strings to every ARB file.
- Add tests based on `docs/ai/VALIDATION_MATRIX.md`.
- Run codegen when annotations or localization change:

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## Generated Skeleton vs Completed Feature

A generated skeleton is only a starting point. It may compile after codegen, but
it still contains placeholder domain fields, endpoint paths, and TODOs.

A completed full-layer feature must have:

- real domain entity fields and behavior;
- datasource API/storage contract;
- DTO/model mapping to domain entities;
- repository contract and implementation;
- use cases for feature actions;
- Riverpod controller/provider wiring;
- page/widgets if user-visible;
- route registration if navigable;
- localized user-facing strings;
- tests for changed behavior;
- validation proof in the final response.

## Adding a Route

Use GoRouter in `lib/core/routing/app_router.dart`.

- Put route names/paths in `lib/core/routing/route_names.dart`.
- Keep route builders thin.
- Do auth redirects in router-level redirect logic.
- Validate with a route test or manual navigation proof note.

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

3. Use `context.l10n.key` from
   `lib/core/localization/app_localizations_x.dart`.

## Adding Assets

1. Put assets under `assets/images/` or another declared assets folder.
2. Run FlutterGen if assets are referenced in Dart:

```bash
dart run build_runner build --delete-conflicting-outputs
```

3. Prefer generated asset references when available.

## Adding API Calls

- Use `dioProvider`.
- Keep Dio calls in datasource classes only.
- Map network errors via existing network exception utilities.
- Keep DTO parsing in `data/models` or datasource layer.
- Keep domain entities free from transport-only details.
- Add repository/datasource tests with mocktail or fakes.

## Testing Pattern

Use `mocktail` or hand-written fakes.

Useful test categories:

- Widget tests for pages/shared widgets.
- Provider tests with `ProviderContainer`.
- Repository tests with mocked or fake datasource/API.
- Use-case tests for domain behavior/delegation.

## Import Convention

Within a feature, relative imports are acceptable and match the generator.
Use package imports for cross-feature, core, shared, and test imports when that
keeps boundaries clearer.

## Common Mistakes to Avoid

- Do not introduce GetX/GetIt.
- Do not introduce BLoC/Cubit.
- Do not put API calls in widgets.
- Do not put UI logic in repositories.
- Do not commit secrets.
- Do not manually edit generated files.
- Do not make broad unrelated refactors while implementing a small task.
- Do not leave generated `TODO(<feature>)` items unresolved in completed work.

## Final Response Contract

Include:

- files changed summary
- validation commands run
- blockers, if any
- follow-up needed, if any
