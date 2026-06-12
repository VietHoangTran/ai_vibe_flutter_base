# CODEMAP / AI Quickstart

This map helps AI agents find the right files quickly before making changes.
For rules and policy, `AGENTS.md` and `CLAUDE.md` remain authoritative.

## Agent rules and read order

Start with `AGENTS.md`; its "Read Order" section is the canonical list of all
harness docs.

Non-negotiables:

- Android and iOS only.
- Use Riverpod annotations, GoRouter, Dio, and feature-first Clean Architecture.
- Do not introduce GetX, GetIt, BLoC/Cubit, another router, or another HTTP
  client unless a human explicitly approves it.
- Do not manually edit generated files.
- Localize user-facing strings.
- Run `scripts/quality_check.sh` before final response or report the blocker.

## Architecture at a glance

Feature code follows this flow:

```text
Page/widget → Riverpod controller → use case → repository contract → repository implementation → datasource/API/storage
```

Canonical feature layout:

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

Create new feature skeletons with:

```bash
dart run tools/feature_cli.dart <feature_name> --dry-run
dart run tools/feature_cli.dart <feature_name>
```

## App composition

- `lib/main.dart` - app entrypoint.
- `lib/app/bootstrap.dart` - Flutter binding, app bootstrap, top-level error
  handling, and `ProviderScope` setup.
- `lib/app/app.dart` - `MaterialApp.router`, theme, locale, localization
  delegates, and app router wiring.

If the task changes app-wide theme, locale, routing, or bootstrapping, inspect
`lib/app/` before editing feature code.

## Core infrastructure

### Config and environments

- `lib/core/config/app_config.dart`
- `docs/development/ENVIRONMENTS.md`
- `scripts/flutter_env.sh`
- `scripts/flutter_dev.sh`
- `scripts/flutter_staging.sh`
- `scripts/flutter_prod.sh`

Use env files to feed compile-time Dart defines. Do not put server secrets in
mobile env files because compile-time defines are embedded in built apps.

### Routing

- `lib/core/routing/app_router.dart`
- `lib/core/routing/route_names.dart`
- `docs/development/ROUTING.md`

Route constants live in `route_names.dart`. GoRouter registration and auth
redirect logic live in `app_router.dart`. Keep route builders thin.

### Networking

- `lib/core/network/dio_provider.dart`
- `lib/core/network/auth_interceptor.dart`
- `lib/core/network/auth_token_store.dart`
- `lib/core/network/token_refresher.dart`
- `lib/core/network/refresh_token_interceptor.dart`
- `lib/core/network/network_exception_mapper.dart`
- `lib/core/error/app_exception.dart`

Use `dioProvider`; do not create global singleton Dio instances. Widgets/pages
must not call Dio directly. Convert transport/model data to domain entities at
repository boundaries.

`AuthInterceptor` attaches the access token read from `authTokenStoreProvider`.
The auth flow persists tokens via that store on sign-in and clears them on
sign-out. To enable refresh-on-401, override `tokenRefresherProvider` with a
real `TokenRefresher` (the default is a no-op, so 401s propagate unchanged);
`RefreshTokenInterceptor` then transparently retries the failed request.

### Connectivity

- `lib/core/network/connectivity_service.dart`
- `lib/core/network/connectivity_status_provider.dart`
- `lib/shared/widgets/offline_banner.dart`

`connectivityStatusProvider` streams `ConnectivityStatus` (online/offline) from
`connectivity_plus`. `OfflineBanner` (wired in `app.dart`) shows a banner while
offline. Status reflects the active transport, not real reachability, so treat
it as a hint, not a guarantee.

### Monitoring

- `lib/core/monitoring/crash_reporter.dart`

`bootstrap()` routes `FlutterError.onError` and uncaught zone errors to
`crashReporterProvider`. The default `LoggingCrashReporter` only logs; override
the provider to forward to Sentry/Crashlytics. Never put tokens or PII in
breadcrumbs.

### Storage

- `lib/core/storage/secure_storage_provider.dart`
- `lib/core/storage/secure_storage_repository.dart`
- `lib/core/storage/shared_preferences_provider.dart`

Use secure storage for sensitive values and shared preferences for non-sensitive
preferences. Feature code should prefer core providers/repositories over direct
client construction.

### Errors and logging

- `lib/core/error/app_exception.dart`
- `lib/core/utils/app_logger.dart`

Wrap lower-level failures in app exceptions where appropriate. Do not log
credentials, tokens, or sensitive response data.

### Localization

- `assets/l10n/app_en.arb`
- `assets/l10n/app_vi.arb`
- `assets/l10n/app_ja.arb`
- `lib/core/localization/app_localizations_x.dart`
- `lib/core/localization/supported_locales.dart`
- `lib/core/localization/l10n/` generated files
- `docs/development/I18N.md`

Use `context.l10n.someKey`. Add keys to every supported ARB file, then run
`flutter gen-l10n`. Do not manually edit generated localization Dart files.

### Theme tokens

- `lib/core/theme/app_theme.dart`
- `lib/core/theme/app_spacing.dart`
- `lib/core/theme/app_durations.dart`
- `lib/core/theme/theme_mode_provider.dart`

Prefer shared spacing, duration, and theme tokens instead of scattering magic
numbers in feature UI.

## Shared UI and extensions

- `lib/shared/extensions/context_extensions.dart`
- `lib/shared/widgets/app_button.dart`
- `lib/shared/widgets/app_text_field.dart`
- `lib/shared/widgets/async_value_view.dart`
- `lib/shared/widgets/dismiss_keyboard.dart`
- `lib/shared/widgets/app_snack_bar.dart`
- `lib/shared/widgets/pressable.dart`
- `lib/shared/widgets/fade_slide_in.dart`
- `lib/shared/widgets/brand_mark.dart`

Prefer shared widgets before creating one-off UI. If a feature-local widget
becomes reusable, move it to `lib/shared/widgets/`.

## Design-to-code and specs

- `docs/design/COMPONENT_MAP.md` - Figma component ↔ Flutter widget/token map.
  Consult before writing any UI from a design.
- `docs/specs/` - approved feature specs and API contracts (templates in
  `docs/templates/feature-spec.md` and `docs/templates/api-contract.md`).
- `test/goldens/` - golden tests (`images/`) and Figma reference screenshots
  (`reference/`); see `test/goldens/README.md`.
- `integration_test/app_smoke_test.dart` - device boot smoke test.
- `.claude/skills/` - project skills: `/spec`, `/figma-screen`,
  `/figma-tokens`, `/run-app`.

## Reference feature: auth

Use `lib/features/auth/` as the canonical full-layer reference feature.

Important files:

- `lib/features/auth/presentation/controllers/auth_controller.dart`
- `lib/features/auth/presentation/pages/login_page.dart`
- `lib/features/auth/presentation/pages/home_page.dart`
- `lib/features/auth/domain/entities/app_user.dart`
- `lib/features/auth/domain/repositories/auth_repository.dart`
- `lib/features/auth/domain/usecases/sign_in_usecase.dart`
- `lib/features/auth/domain/usecases/sign_out_usecase.dart`
- `lib/features/auth/data/datasources/auth_remote_data_source.dart`
- `lib/features/auth/data/datasources/auth_local_data_source.dart`
- `lib/features/auth/data/models/user_model.dart`
- `lib/features/auth/data/repositories/auth_repository_impl.dart`
- `lib/features/auth/data/repositories/auth_repository_provider.dart`

Auth/session/token work is high-risk. Clarify scope, preserve layer boundaries,
avoid sensitive logging, and provide strong validation proof.

## Reference feature: settings

Use `lib/features/settings/` as the reference for persisted preferences and
local datasource work.

Important files:

- `lib/features/settings/presentation/controllers/settings_controller.dart`
- `lib/features/settings/presentation/pages/settings_page.dart`
- `lib/features/settings/presentation/widgets/settings_content.dart`
- `lib/features/settings/presentation/widgets/settings_section.dart`
- `lib/features/settings/domain/entities/app_settings.dart`
- `lib/features/settings/domain/repositories/settings_repository.dart`
- `lib/features/settings/domain/usecases/get_settings_usecase.dart`
- `lib/features/settings/domain/usecases/update_locale_usecase.dart`
- `lib/features/settings/domain/usecases/update_theme_mode_usecase.dart`
- `lib/features/settings/data/datasources/settings_local_data_source.dart`
- `lib/features/settings/data/models/settings_model.dart`
- `lib/features/settings/data/repositories/settings_repository_impl.dart`
- `lib/features/settings/data/repositories/settings_repository_provider.dart`

Settings shows immutable controller updates, SharedPreferences-backed storage,
and app-wide theme/locale wiring.

## Common task recipes

### Add a feature

1. Run `dart run tools/feature_cli.dart <feature_name> --dry-run`.
2. Generate with guidance flags if useful.
3. Replace generated `TODO(<feature>)` items.
4. `--with-route` auto-registers the route (verify the anchor edits);
   without it, wire the route manually. Localization strings always need
   manual ARB updates.
5. Add tests by layer.
6. Run `scripts/quality_check.sh`.

### Add a route

1. Update `lib/core/routing/route_names.dart`.
2. Register a `GoRoute` in `lib/core/routing/app_router.dart`.
3. Keep redirect logic centralized.
4. Validate with a route test or manual navigation proof note.

### Add localized text

1. Update all ARB files.
2. Run `flutter gen-l10n`.
3. Use `context.l10n.key`.

### Add an API call

1. Add endpoint logic in feature datasource.
2. Parse DTO/model in `data/models`.
3. Map to domain in repository implementation.
4. Add repository/datasource tests.

### Add a persisted setting

Follow `lib/features/settings/`: local datasource, repository contract,
repository implementation, use case, Riverpod controller, and UI wiring.

### Add a shared widget

Create feature-local widgets first when usage is narrow. Move to
`lib/shared/widgets/` once it is reused across features.

## Testing and validation

Use `docs/ai/VALIDATION_MATRIX.md` to choose proof.

Standard quality gate:

```bash
scripts/quality_check.sh
```

Expanded commands:

```bash
flutter pub get
scripts/generate.sh
dart format --set-exit-if-changed .
dart analyze --fatal-infos --fatal-warnings
flutter test --coverage
scripts/check_coverage.sh
```

Coverage gate: `scripts/check_coverage.sh` fails when line coverage of
non-generated `lib/` code drops below the threshold (baseline 65%, long-term
target 80% for business logic). CI runs the same gate in the Code Quality job.

If tools are unavailable, report the exact blocker and the local commands a
human should run.

Doc freshness: when adding, deleting, or renaming files under `lib/core/`,
`lib/shared/`, `tools/`, or `scripts/`, update this codemap (and other docs as
relevant) and run `scripts/check_doc_freshness.sh --local`. A Claude Code Stop
hook and the `Doc Freshness` CI job enforce the same rule.

## Anti-patterns and approval-required changes

Do not introduce without explicit approval:

- GetX
- GetIt/service locator
- BLoC/Cubit
- another router
- another HTTP client
- global mutable singleton services
- web, Linux, macOS, or Windows platform support

Do not manually edit:

- `*.g.dart`
- `*.freezed.dart`
- generated localization files
- Flutter tool generated cache files

Before adding dependencies, read `docs/development/DEPENDENCY_POLICY.md`.
