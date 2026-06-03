# AI Vibe Coding Harness

This repository uses a lightweight harness for AI-assisted Flutter development.

The app is for users. The harness is for agents.

## Purpose

The harness helps AI coding agents:

1. Understand the task before coding.
2. Classify risk and scope.
3. Follow the existing Flutter architecture.
4. Produce validation proof.
5. Record important architecture decisions.

## Workflow

```text
Human intent
  → feature intake
  → scoped implementation
  → validation proof
  → decision/story update if needed
  → final summary
```

## Read Order for Agents

1. `AGENTS.md`
2. `docs/ai/AI_CODING_GUIDE.md`
3. `docs/ai/FEATURE_INTAKE.md`
4. `docs/ai/VALIDATION_MATRIX.md`
5. `docs/ai/PATTERNS.md`
6. `docs/ai/ANTI_PATTERNS.md`
7. `docs/ai/CHECKLIST.md`

## When to Create a Story

Use `docs/templates/story.md` and save a copy under `docs/stories/` when:

- the task is high-risk
- the feature spans multiple layers
- scope needs to be preserved across sessions
- a human decision must be tracked during implementation

Tiny tasks do not need story files.

## When to Create a Decision

Use `docs/templates/decision.md` and save a copy under `docs/decisions/` when:

- a stack choice changes
- a dependency policy changes
- platform support changes
- architecture convention changes
- a high-risk alternative is accepted or rejected

## Validation

Before finishing, run:

```bash
scripts/quality_check.sh
```

If a command cannot run, report the exact blocker and the commands that should be run locally.
