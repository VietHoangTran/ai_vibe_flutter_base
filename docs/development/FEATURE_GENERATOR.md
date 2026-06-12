# Feature Generator

Use `tools/feature_cli.dart` to create feature skeletons that match this base.
AI agents should use this tool instead of manually creating many feature files.
This prevents structure drift and keeps dependencies wired consistently.

## Usage

```bash
dart run tools/feature_cli.dart <feature_name> [--dry-run] [--force] [--with-route] [--with-localization] [--with-story]
```

Examples:

```bash
dart run tools/feature_cli.dart profile --dry-run
dart run tools/feature_cli.dart profile
dart run tools/feature_cli.dart profile --with-route --with-localization
```

## Options

| Option | Behavior |
| --- | --- |
| `--dry-run` | Prints files that would be created without writing them. |
| `--force` | Overwrites existing generated target files. Use carefully. |
| `--with-route` | Auto-registers the route: edits `lib/core/routing/route_names.dart` and `lib/core/routing/app_router.dart` at the `// feature_cli:` anchor comments. Re-running is idempotent; if an anchor is missing or the route already exists, the edit is skipped with a warning. With `--dry-run` it only prints what would be registered. Run `build_runner` afterwards so `app_router.g.dart` picks up the route. |
| `--with-localization` | Adds compile-safe TODO guidance for replacing the title with `context.l10n.<feature>Title` after ARB keys exist, and prints ARB keys to add. It does not edit ARB files or generate code that depends on missing l10n getters. |
| `--with-story` | Prints story creation guidance for multi-layer or handoff-heavy work. |

## Generated Structure

```text
lib/features/<feature>/
├── data/
│   ├── datasources/<feature>_remote_data_source.dart
│   ├── models/<feature>_model.dart
│   └── repositories/
│       ├── <feature>_repository_impl.dart
│       └── <feature>_repository_provider.dart
├── domain/
│   ├── entities/<feature>.dart
│   ├── repositories/<feature>_repository.dart
│   └── usecases/get_<feature>_usecase.dart
└── presentation/
    ├── controllers/<feature>_controller.dart
    ├── pages/<feature>_page.dart
    └── widgets/<feature>_content.dart

test/features/<feature>/
└── get_<feature>_usecase_test.dart
```

## Generated Skeleton vs Completed Feature

A generated skeleton is only a starting point. It contains placeholder fields,
endpoint paths, and `TODO(<feature>)` markers.

A completed full-layer feature must include:

- real entity/model fields;
- real API or storage contract;
- repository contract and implementation;
- use cases for feature actions;
- Riverpod controller/provider wiring;
- page/widgets if user-visible;
- route registration if navigable;
- localized strings for user-facing text;
- tests required by `docs/ai/VALIDATION_MATRIX.md`;
- `scripts/quality_check.sh` validation proof.

Use `lib/features/auth/` as the canonical full-layer reference feature. Use
`lib/features/settings/` as the reference for local persistence/preferences.

## After Generation

1. Replace generated `TODO(<feature>)` items.
2. Replace placeholder entity/model fields.
3. Replace placeholder API endpoint or swap in local storage logic when needed.
4. If you did not pass `--with-route`, register the route manually (or re-run
   the generator with `--with-route`; route edits are idempotent).
5. Add localization keys manually if the feature shows UI text.
6. Run codegen:

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   flutter gen-l10n
   ```

7. Add/update tests.
8. Run:

   ```bash
   scripts/quality_check.sh
   ```

## Import Convention

Generated files use relative imports inside a feature. Tests use package imports.
For cross-feature/core/shared imports, prefer the style already used in the
nearby files.

## Generator Validation

When changing the generator, run:

```bash
flutter test test/tools/feature_cli_test.dart
dart run tools/feature_cli.dart sample_feature --dry-run
dart run tools/feature_cli.dart sample_feature --dry-run --with-route --with-localization --with-story
```

The generator must not edit generated files (`*.g.dart`), ARB files, or story
files — it prints follow-up steps for those. The only files it may edit are
`route_names.dart` and `app_router.dart`, and only at the `// feature_cli:`
anchor comments when `--with-route` is passed.
