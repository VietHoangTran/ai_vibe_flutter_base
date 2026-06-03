# AGENTS.md - AI Vibe Flutter Base

This repository is intended to be used heavily by AI coding agents. Follow these rules unless a human explicitly overrides them.

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

Use Dart define files:

```bash
flutter run --dart-define-from-file=config/staging.json
flutter run --dart-define-from-file=config/prod.json
```

Shortcut scripts:

```bash
scripts/flutter_dev.sh
scripts/flutter_staging.sh
scripts/flutter_prod.sh
```

Do not commit real secrets in config files. Use placeholders in this base.

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
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
dart format .
dart analyze --fatal-infos --fatal-warnings
flutter test
```

## Do Not Copy From Example Base Blindly

The example base uses GetX/GetIt. This repo uses Riverpod/go_router. Translate ideas; do not paste incompatible patterns.
