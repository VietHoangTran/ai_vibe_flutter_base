# AGENTS.md - AI Vibe Flutter Base

This repository is intended to be used heavily by AI coding agents. Follow these rules unless a human explicitly overrides them.

## Read Order

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
dart run tools/feature_cli.dart profile
```

Then add routes manually in `lib/core/routing/app_router.dart` if the feature needs navigation.

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

## Shared UI

Prefer shared components before introducing one-off UI:

- `AppButton`
- `AppTextField`
- `AsyncValueView`
- `DismissKeyboard`
- `showAppSnackBar`

If a component becomes reusable, put it in `lib/shared/widgets/`.

## Networking

Use `dioProvider` from `lib/core/network/dio_provider.dart`.

- Do not create global singleton Dio instances.
- Do not mutate Dio base URL per request.
- Keep auth/refresh-token logic in interceptors or dedicated services.
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

## Do Not Copy From Example Base Blindly

The example base uses GetX/GetIt. This repo uses Riverpod/go_router. Translate ideas; do not paste incompatible patterns.
