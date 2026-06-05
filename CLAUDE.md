# CLAUDE.md

Read `AGENTS.md` first.

## Project Identity

This is AI Vibe Flutter Base: a mobile-only Flutter base designed for AI vibe coding.

## Required Read Order

Read `AGENTS.md` first; its "Read Order" section is the canonical list of all
remaining harness docs. Do not duplicate that list here.

## Common Commands

```bash
scripts/generate.sh
scripts/quality_check.sh
dart run tools/feature_cli.dart <feature_name> --dry-run
dart run tools/feature_cli.dart <feature_name>
```

## Non-negotiables

- Use Riverpod, GoRouter, Dio, and feature-first Clean Architecture.
- Android and iOS only.
- Do not introduce GetX, GetIt, BLoC/Cubit, another router, or another HTTP client unless explicitly approved.
- Do not edit generated files manually.
- Use localization for user-facing strings.
- Run `scripts/quality_check.sh` before final response or report the blocker.

## Final Response Requirements

Include:

- files changed summary
- validation commands run
- blockers, if any
- follow-up needed, if any
