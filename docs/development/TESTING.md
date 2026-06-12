# Testing Guide

Use tests to prove behavior, not boilerplate.

## Widget Tests

Use for:

- reusable widgets
- screens with conditional UI
- user interactions

Example targets:

- `AppButton`
- form validation
- loading/error/data states

## Provider Tests

Use `ProviderContainer` for Riverpod providers/controllers.

Use for:

- controller state
- locale/storage behavior
- dependency override scenarios

## Repository Tests

Use `mocktail` or fakes.

Use for:

- data mapping
- error handling
- datasource orchestration

## What Not to Test

Usually skip:

- generated files
- pure boilerplate
- trivial pass-through constructors

## Coverage Gate

`scripts/quality_check.sh` and CI run `flutter test --coverage` followed by
`scripts/check_coverage.sh`, which fails when line coverage of non-generated
`lib/` code drops below the threshold (baseline 65%; raise it as coverage
improves — the long-term target for business logic is 80%).

Override the threshold locally when ratcheting:

```bash
scripts/check_coverage.sh 70
# or
MIN_COVERAGE=70 scripts/check_coverage.sh
```

Note: `lcov.info` only contains files loaded by at least one test, so files
never imported by any test are invisible to the gate. New features must ship
with tests (see `docs/ai/VALIDATION_MATRIX.md`) so they enter the measured set.

## Commands

```bash
flutter test
flutter test --coverage && scripts/check_coverage.sh
```

Full quality gate:

```bash
scripts/quality_check.sh
```
