# AI Vibe Flutter Base

Base Flutter cho AI coding và vibe coding: Clean Architecture theo feature-first, Riverpod 3, GoRouter, Dio/Retrofit, Freezed, JSON Serializable, strict lint, test-ready.

## Stack

- Flutter 3.44.1 / Dart 3.12.1
- State management + DI: `flutter_riverpod` + `riverpod_annotation`
- Navigation: `go_router`
- Network: `dio` + `retrofit`
- Immutable models: `freezed` + `json_serializable`
- Local storage: `shared_preferences`, `flutter_secure_storage`
- Lint: `very_good_analysis`

## Architecture

```text
lib/
├── app/                 # App root, bootstrap
├── core/                # Shared infra: config, theme, routing, network, storage
├── features/            # Feature-first modules
│   └── auth/
│       ├── data/        # DTOs, datasources, repository implementations
│       ├── domain/      # Entities, repository contracts, use cases
│       └── presentation/# Pages, widgets, Riverpod controllers
└── shared/              # Shared widgets/components
```

Rule: UI → controller/usecase → repository contract → repository implementation → datasource.

## Commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format .
dart analyze --fatal-infos --fatal-warnings
flutter test
flutter run
```

## AI Coding

This base is designed for AI-assisted development. Read these files before extending it:

- `AGENTS.md` - repository rules for AI coding agents
- `docs/ai/AI_CODING_GUIDE.md` - practical implementation guide
- `docs/development/FEATURE_GENERATOR.md` - feature generator usage
- `docs/development/ENVIRONMENTS.md` - staging/prod run and build commands

Create feature skeletons with:

```bash
dart run tools/feature_cli.dart profile --dry-run
dart run tools/feature_cli.dart profile
```

## Naming conventions

- Files/folders: `snake_case.dart`
- Classes/enums/extensions: `PascalCase`
- Variables/functions: `camelCase`
- Features own their data/domain/presentation layers.

## Environments

Use Dart define files:

```bash
scripts/flutter_dev.sh
scripts/flutter_staging.sh
scripts/flutter_prod.sh

flutter run --dart-define-from-file=config/staging.json
flutter run --dart-define-from-file=config/prod.json
```

## Localization

Starter locales: `en`, `vi`, `ja`.

Add user-facing strings to `assets/l10n/*.arb`, then use `context.l10n.key`.
