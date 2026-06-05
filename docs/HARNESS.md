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

The canonical read order lives in the "Read Order" section of `AGENTS.md`.
Start there; this file is the first stop on that list.

## Project Skills

Reusable workflows live in `.claude/skills/` and are invoked as slash
commands:

| Skill | Purpose |
| --- | --- |
| `/spec` | Raw requirement → reviewed feature spec in `docs/specs/` |
| `/figma-screen` | Figma link → Flutter screen via component map + tokens |
| `/figma-tokens` | Figma variables vs `lib/core/theme/` gap report |
| `/run-app` | Boot simulator/emulator and capture screenshot proof |

Supporting artifacts:

- `docs/templates/feature-spec.md`, `docs/templates/api-contract.md`
- `docs/design/COMPONENT_MAP.md` — Figma ↔ widget/token mapping
- `test/goldens/` — golden tests plus Figma reference screenshots

## When to Create a Story

Use `docs/templates/story.md` and save a copy under `docs/stories/` when:

- the task is high-risk
- the feature spans multiple layers
- scope needs to be preserved across sessions
- a human decision must be tracked during implementation

Tiny tasks do not need story files.

See `docs/stories/0001-example-auth-token-loop.md` for a worked example of
the expected level of detail.

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

## Doc Freshness Guard

Docs must not drift from the code. When files are added, deleted, or renamed
under `lib/core/`, `lib/shared/`, `tools/`, or `scripts/`, update
`docs/CODEMAP.md` (and `AGENTS.md` or `docs/ai/*` when conventions change) in
the same change.

Enforcement layers:

1. Self-check: `scripts/check_doc_freshness.sh --local`
2. Claude Code `Stop` hook in `.claude/settings.json` — blocks session
   completion once when the check fails. A `PostToolUse` hook also
   auto-formats edited Dart files (`.claude/hooks/dart_format_post.sh`).
3. `Doc Freshness` CI job in `.github/workflows/flutter_ci.yml` — runs the
   same script against the PR base branch.

The guard only fires on structural changes; in-place edits pass without a doc
update.
