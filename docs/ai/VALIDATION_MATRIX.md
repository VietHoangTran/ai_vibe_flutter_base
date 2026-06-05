# Validation Matrix

Use this matrix to decide what proof is required before completing a task.

| Change type | Required proof |
| --- | --- |
| Docs-only | `git diff --check` |
| AI docs/read-order changes | links reviewed + `git diff --check` |
| Script/tooling | run the script or shell syntax inspection if tool is unavailable |
| Feature generator/tooling | CLI dry-run + generator tests + `scripts/quality_check.sh` |
| UI widget | widget test or manual UI proof note |
| Page/screen | widget test or manual navigation proof note |
| Screen built from a Figma design | widget test + golden test + Figma reference screenshot in `test/goldens/reference/` |
| Design token change (`lib/core/theme/`) | goldens reviewed/updated intentionally + affected screens checked |
| Riverpod controller | provider test |
| Use case/domain logic | unit test |
| Repository/data mapping | unit test with mocktail or fake datasource |
| Dio datasource | mocked API/Dio test if logic exists |
| Routing | route test or manual navigation proof note |
| Localization | all supported ARB files updated + `flutter gen-l10n` |
| Native Android/iOS config | platform build command or exact blocker |
| Dependency change | `flutter pub get` + analyze + test |
| Generated code | `flutter gen-l10n` / `build_runner` rerun |
| Structural change (add/delete/rename in `lib/core/`, `lib/shared/`, `tools/`, `scripts/`) | doc update + `scripts/check_doc_freshness.sh --local` |
| App boot / cross-feature flow | `flutter test integration_test -d <device_id>` (device required) or `/run-app` screenshot proof |

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

## Generator Validation

When changing `tools/feature_cli.dart`, run at least:

```bash
flutter test test/tools/feature_cli_test.dart
dart run tools/feature_cli.dart sample_feature --dry-run
dart run tools/feature_cli.dart sample_feature --dry-run --with-route --with-localization --with-story
```

## If Tools Are Missing

If Flutter/Dart is unavailable, say so clearly and include:

- command attempted
- error/blocker
- commands the human should run locally
- any fallback checks performed, such as `git diff --check` or
  `sh -n scripts/quality_check.sh`
