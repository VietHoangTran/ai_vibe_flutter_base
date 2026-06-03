# Validation Matrix

Use this matrix to decide what proof is required before completing a task.

| Change type | Required proof |
| --- | --- |
| Docs-only | `git diff --check` |
| Script/tooling | run the script or shellcheck-style inspection if tool is unavailable |
| UI widget | widget test or manual UI proof note |
| Page/screen | widget test or manual navigation proof note |
| Riverpod controller | provider test |
| Use case/domain logic | unit test |
| Repository/data mapping | unit test with mocktail or fake datasource |
| Dio datasource | mocked API/Dio test if logic exists |
| Routing | route test or manual navigation proof note |
| Localization | all supported ARB files updated + `flutter gen-l10n` |
| Native Android/iOS config | platform build command or exact blocker |
| Dependency change | `flutter pub get` + analyze + test |
| Generated code | `flutter gen-l10n` / `build_runner` rerun |

## Standard Quality Gate

```bash
scripts/quality_check.sh
```

Equivalent expanded commands:

```bash
flutter pub get
scripts/generate.sh
dart format --set-exit-if-changed .
dart analyze --fatal-infos --fatal-warnings
flutter test
```

## If Tools Are Missing

If Flutter/Dart is unavailable, say so clearly and include:

- command attempted
- error/blocker
- commands the human should run locally
- any fallback checks performed, such as `git diff --check`
