# AI Vibe Flutter Base

Base Flutter cho AI coding và vibe coding: Clean Architecture theo feature-first, Riverpod 3, GoRouter, Dio/Retrofit, Freezed, JSON Serializable, strict lint, test-ready.

## Stack

- Flutter 3.45 / Dart 3.13 (SDK constraint `>=3.12.1`)
- State management + DI: `flutter_riverpod` ^3.3.1 + `riverpod_annotation` ^4.0.2
- Navigation: `go_router` ^17.3.0
- Network: `dio` ^5.9.2 + `retrofit` ^4.9.2
- Immutable models: `freezed` + `json_serializable`
- Local storage: `shared_preferences` ^2.5.5, `flutter_secure_storage` ^10.3.1
- In-app update: `upgrader` ^13.5.0
- Lint: `very_good_analysis` ^10.2.0

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
scripts/generate.sh
scripts/quality_check.sh
flutter run
```

Expanded quality gate:

```bash
flutter pub get
scripts/generate.sh
dart format --set-exit-if-changed .
dart analyze --fatal-infos --fatal-warnings
flutter test --coverage
scripts/check_coverage.sh
```

## App icon & splash

Both are generated from a single source image each. To change one, replace its
source image (keep the same filename), then run the matching script.

```bash
# Icon: replace assets/images/icon_app_launcher.png (1024x1024 recommended)
scripts/generate_icons.sh

# Splash: replace assets/images/splash.png (transparent PNG works best)
scripts/generate_splash.sh
```

## AI Coding

This base is designed for AI-assisted development. Read these files before extending it:

- `AGENTS.md` - repository rules for AI coding agents
- `CLAUDE.md` - Claude Code focused instructions
- `docs/HARNESS.md` - lightweight harness workflow
- `docs/ai/AI_CODING_GUIDE.md` - practical implementation guide
- `docs/ai/TASK_PLAYBOOK.md` - tactical checklists for common agent tasks
- `docs/CODEMAP.md` - quick map of app architecture and key files
- `docs/ai/FEATURE_INTAKE.md` - task/risk classification
- `docs/ai/VALIDATION_MATRIX.md` - required validation proof
- `docs/development/FEATURE_GENERATOR.md` - feature generator usage
- `docs/development/ENVIRONMENTS.md` - staging/prod run and build commands

Create feature skeletons with:

```bash
dart run tools/feature_cli.dart profile --dry-run
dart run tools/feature_cli.dart profile
```

### Project skills (Claude Code)

Reusable agent workflows live in `.claude/skills/` and run as slash commands:

| Skill | Purpose |
| --- | --- |
| `/spec` | Raw requirement (text/Jira/Figma/image) → reviewed feature spec in `docs/specs/` |
| `/figma-screen` | Figma link → Flutter screen using `docs/design/COMPONENT_MAP.md` + theme tokens |
| `/figma-tokens` | Gap report: Figma variables vs `lib/core/theme/` tokens |
| `/run-app` | Boot simulator/emulator and capture screenshot proof |

Design-to-code references:

- `docs/design/COMPONENT_MAP.md` - Figma component ↔ shared widget/token map
- `docs/templates/feature-spec.md`, `docs/templates/api-contract.md` - spec templates
- `test/goldens/README.md` - golden test convention with Figma reference screenshots
- `integration_test/app_smoke_test.dart` - device boot smoke test (`flutter test integration_test -d <device_id>`)

## Naming conventions

- Files/folders: `snake_case.dart`
- Classes/enums/extensions: `PascalCase`
- Variables/functions: `camelCase`
- Features own their data/domain/presentation layers.

## Environments

Use env files. Only `env/.env.example` and `env/.env.dev` are committed; real staging/prod env files are ignored.

```bash
cp env/.env.example env/.env.staging
cp env/.env.example env/.env.prod

scripts/flutter_dev.sh
scripts/flutter_staging.sh
scripts/flutter_prod.sh
```

Build with env files:

```bash
scripts/flutter_env.sh env/.env.staging build apk --release
scripts/flutter_env.sh env/.env.prod build apk --release
```

## Localization

Starter locales: `en`, `vi`, `ja`.

Add user-facing strings to `assets/l10n/*.arb`, then use `context.l10n.key`.
