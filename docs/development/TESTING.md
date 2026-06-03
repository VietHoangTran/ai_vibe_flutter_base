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

## Commands

```bash
flutter test
```

Full quality gate:

```bash
scripts/quality_check.sh
```
