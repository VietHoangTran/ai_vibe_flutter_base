# CLAUDE.md

Read `AGENTS.md` first.

## Project Identity

This is AI Vibe Flutter Base: a mobile-only Flutter base designed for AI vibe coding.

## Required Read Order

1. `AGENTS.md`
2. `docs/HARNESS.md`
3. `docs/ai/AI_CODING_GUIDE.md`
4. `docs/ai/TASK_PLAYBOOK.md`
5. `docs/ai/FEATURE_INTAKE.md`
6. `docs/ai/VALIDATION_MATRIX.md`
7. `docs/ai/PATTERNS.md`
8. `docs/ai/ANTI_PATTERNS.md`
9. `docs/ai/CHECKLIST.md`

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
