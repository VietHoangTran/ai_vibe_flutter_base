# Decision 0003: Use Harness-lite for AI Coding

## Status

Accepted

## Context

The project is designed for AI vibe coding. The referenced `repository-harness` project provides a strong model for intake, validation, stories, and decisions. Pulling in a full CLI/durable harness is unnecessary for this lightweight Flutter base.

## Decision

Use a Markdown-and-scripts Harness-lite:

- `docs/HARNESS.md`
- AI intake, patterns, anti-patterns, validation matrix, prompts, checklist
- story and decision templates
- quality/generation scripts
- Claude Code instructions

## Consequences

- Agents get clear workflow without extra runtime dependencies.
- Human reviewers get better proof and scope tracking.
- If the project grows, a fuller harness can be considered later.

## Alternatives considered

- Full repository-harness CLI: deferred due to complexity.
- No harness: rejected because the repository goal is AI-friendly coding.

## Date

2026-06-03
