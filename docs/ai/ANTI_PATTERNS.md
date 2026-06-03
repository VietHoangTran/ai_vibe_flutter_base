# AI Anti-patterns

Avoid these unless a human explicitly approves an exception.

## Architecture Drift

Do not introduce:

- GetX
- GetIt/service locator
- BLoC/Cubit
- another router
- another HTTP client
- global mutable singleton services

## Layer Violations

Do not:

- call Dio directly from widgets/pages
- put business logic in widgets
- put UI concerns in repositories
- expose transport-only DTO details to domain entities
- skip repository interfaces for non-trivial features

## Generated Files

Do not manually edit:

- `*.g.dart`
- `*.freezed.dart`
- generated localization files
- Flutter tool generated cache files

Regenerate instead.

## User-facing Text

Do not hardcode app UI text when it should be localized.

Update all supported ARB files:

- `app_en.arb`
- `app_vi.arb`
- `app_ja.arb`

## Dependency Sprawl

Do not add a dependency just because it is convenient.

Before adding one, check:

- existing Flutter/Dart APIs
- existing project dependencies
- maintenance status
- architecture fit
- test impact

## Platform Drift

This base supports Android and iOS only. Do not add web, Linux, macOS, or Windows unless explicitly requested.

## Scope Creep

Do not perform broad unrelated refactors while solving a small task.
