# Feature Generator

Use `tools/feature_cli.dart` to create feature skeletons that match this base.

## Usage

```bash
dart run tools/feature_cli.dart <feature_name> [--dry-run] [--force]
```

Examples:

```bash
dart run tools/feature_cli.dart profile --dry-run
dart run tools/feature_cli.dart profile
```

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
```

## After Generation

1. Replace placeholder entity/model fields.
2. Replace placeholder API endpoint.
3. Add route if the feature has a page.
4. Add tests.
5. Run `dart analyze --fatal-infos --fatal-warnings` and `flutter test`.

## AI Coding Notes

AI agents should use this tool instead of manually creating many feature files. This prevents structure drift and keeps dependencies wired consistently.
