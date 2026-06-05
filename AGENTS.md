# AGENTS.md - AI Vibe Flutter Base

This repository is intended to be used heavily by AI coding agents. Follow these rules unless a human explicitly overrides them.

## Read Order

This is the canonical read order. Other docs link here instead of duplicating
the list; when adding or renaming AI docs, update only this section.

1. `docs/HARNESS.md`
2. `docs/ai/AI_CODING_GUIDE.md`
3. `docs/ai/TASK_PLAYBOOK.md`
4. `docs/ai/FEATURE_INTAKE.md`
5. `docs/ai/VALIDATION_MATRIX.md`
6. `docs/ai/PATTERNS.md`
7. `docs/ai/ANTI_PATTERNS.md`
8. `docs/ai/CHECKLIST.md`

## Stack

- Flutter + Dart
- Riverpod annotations for state management and dependency injection
- GoRouter for navigation
- Dio for networking
- Freezed/json_serializable where immutable DTOs are useful
- Feature-first Clean Architecture

## Architecture Rules

Use this flow:

```text
UI page/widget → Riverpod controller → use case → repository contract → repository implementation → datasource/API/storage
```

Do not skip layers for feature code unless the feature is genuinely trivial.

Recommended feature layout:

```text
lib/features/<feature>/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── controllers/
    ├── pages/
    └── widgets/
```

## Feature Generator

Use the generator instead of hand-creating feature skeletons:

```bash
dart run tools/feature_cli.dart profile --dry-run
dart run tools/feature_cli.dart profile --with-route
```

Pass `--with-route` to auto-register the route: the generator edits
`route_names.dart` and `app_router.dart` at the `// feature_cli:` anchors
(idempotent). Keep those anchor comments intact so registration keeps working.
Without `--with-route` you must wire the route manually.

## Environments

Use env files and convert them to compile-time Dart defines through `scripts/flutter_env.sh`.

Committed env files:

- `env/.env.example`
- `env/.env.dev`

Ignored env files for real values:

- `env/.env.staging`
- `env/.env.prod`

Shortcut scripts:

```bash
scripts/flutter_dev.sh
scripts/flutter_staging.sh
scripts/flutter_prod.sh
```

Do not commit real secrets in env files. Use placeholders in this base. Remember that Flutter compile-time defines are embedded in the built app, so do not put server secrets in mobile env files.

## Localization

Use Flutter gen-l10n files in `assets/l10n/`.

Supported starter locales:

- `en`
- `vi`
- `ja`

Use:

```dart
context.l10n.someKey
```

from `lib/core/localization/app_localizations_x.dart`.

## Specs Before Code

For Normal and High-risk features, create a spec under `docs/specs/` from
`docs/templates/feature-spec.md` (use the `/spec` skill). API work also gets
`docs/templates/api-contract.md` — generate models from the contract, never
guess field names.

## Design-to-Code (Figma)

When implementing UI from a design:

1. Consult `docs/design/COMPONENT_MAP.md` first — reuse mapped widgets and
   tokens; never inline hex colors or raw pixel values from a design file.
2. Use the `/figma-screen` skill for the full Figma → screen pipeline.
3. Use the `/figma-tokens` skill to gap-check Figma variables against
   `lib/core/theme/` before building from a new design file.
4. Design-critical screens get a golden test (`test/goldens/README.md`) and
   their Figma reference screenshot under `test/goldens/reference/`.

## Shared UI

Prefer shared components before introducing one-off UI:

- `AppButton`
- `AppTextField`
- `AsyncValueView` (localized default error state; pass `onRetry` for a retry button)
- `DismissKeyboard`
- `showAppSnackBar`
- `OfflineBanner` (wired globally; reacts to `connectivityStatusProvider`)

If a component becomes reusable, put it in `lib/shared/widgets/` and add a row
to `docs/design/COMPONENT_MAP.md`.

## Networking

Use `dioProvider` from `lib/core/network/dio_provider.dart`.

- Do not create global singleton Dio instances.
- Do not mutate Dio base URL per request.
- Persist/read tokens through `authTokenStoreProvider`, not raw secure storage.
- Token refresh is wired: implement `TokenRefresher` and override
  `tokenRefresherProvider` to enable refresh-on-401. The default is a no-op.
- Report uncaught errors through `crashReporterProvider`, not bare logging.
- Avoid logging sensitive data in production.

## Storage

Use Riverpod providers in `lib/core/storage/`.

For secure values, prefer `secureStorageRepositoryProvider` over directly using `FlutterSecureStorage` in feature code.

## Quality Gates

Before finishing code changes, run:

```bash
scripts/quality_check.sh
```

If Flutter/Dart is unavailable, report the blocker and include the commands that should be run locally.

A `PostToolUse` hook (`.claude/hooks/dart_format_post.sh`) auto-formats edited
Dart files, but `scripts/quality_check.sh` remains the gate.

## Agents and Skills

Project-local skills (in `.claude/skills/`):

- `/spec` — turn a raw requirement into a reviewed feature spec.
- `/figma-screen` — Figma link → Flutter screen pipeline.
- `/figma-tokens` — Figma variables vs `lib/core/theme/` gap report.
- `/run-app` — boot simulator/emulator, capture screenshot proof.

When available in the harness, also use:

- `flutter-reviewer` agent after writing/modifying Flutter code.
- `dart-build-resolver` agent when builds or `dart analyze` fail.
- `dart-flutter-patterns` and `flutter-testing` skills for non-trivial state
  management or test design.

## Doc Freshness

Structural changes (added/deleted/renamed files under `lib/core/`,
`lib/shared/`, `tools/`, or `scripts/`) must ship with a doc update —
usually `docs/CODEMAP.md`, plus `AGENTS.md` or `docs/ai/*` when conventions
change.

This is enforced in three layers:

- `scripts/check_doc_freshness.sh --local` — run it yourself before finishing.
- A Claude Code `Stop` hook (`.claude/settings.json`) blocks the session once
  when the check fails.
- The `Doc Freshness` CI job runs the same script against the PR base branch.

Pure in-place edits (bug fixes that touch no file structure) do not trigger
the guard.

## Do Not Copy From Example Base Blindly

The example base uses GetX/GetIt. This repo uses Riverpod/go_router. Translate ideas; do not paste incompatible patterns.
