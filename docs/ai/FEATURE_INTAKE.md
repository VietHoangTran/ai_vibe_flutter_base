# Feature Intake

Before coding, classify the task. Do not start broad edits until scope and risk are clear.

## Tiny

Examples:

- docs-only edits
- small copy/text updates
- simple rename
- small UI polish
- adding a guide/template file

Rules:

- Story file is not required.
- Keep changes minimal.
- Run quality checks or report blocker.

## Normal

Examples:

- new screen
- new feature slice
- repository/usecase/controller changes
- scoped API integration
- reusable widget with clear purpose
- localization additions

Rules:

- Inspect existing patterns first.
- Use `tools/feature_cli.dart` for new feature skeletons.
- Add or update tests when behavior changes.
- Create a story if the task spans multiple layers or may need handoff.

## High-risk

Examples:

- auth/session/token handling
- permissions/security
- secure storage changes
- native Android/iOS config
- dependency upgrades
- navigation-wide changes
- cross-feature refactor
- architecture convention changes

Rules:

- Ask for clarification if scope is not explicit.
- Create a story before implementation.
- Add decision log if architecture or policy changes.
- Provide strong validation proof.

## Intake Questions

Answer mentally before editing:

1. What is the smallest useful change?
2. Which layers are affected?
3. Does this change user-facing text?
4. Does this require tests?
5. Does this create or modify an architecture decision?
6. What command proves it works?
