# Feature Spec: <feature name>

> Copy this template to `docs/specs/<NNNN>-<feature-slug>.md` before building a
> Normal or High-risk feature. Tiny tasks do not need a spec.
> Fill every section; write "N/A" explicitly instead of deleting sections.

## Summary

One or two sentences: what the user gets when this ships.

## Classification

- Scope (per `docs/ai/FEATURE_INTAKE.md`): Tiny | Normal | High-risk
- Source: <human request / Jira ticket / Figma link / other>

## User Stories

- As a <user>, I want <capability>, so that <benefit>.

## Acceptance Criteria

Use Given/When/Then. Every criterion must be testable.

- Given <precondition>, when <action>, then <observable result>.

## Screens and Navigation

- Screens involved: <list, with Figma links if any>
- Entry points / routes: <route names>
- Navigation result on success / failure / cancel

## Data and API

- API contract: link to `docs/specs/<NNNN>-api-contract.md` or "N/A (local only)"
- Entities/fields involved
- Persistence: secure storage / shared preferences / none

## Edge Cases and Error States

List explicitly; "happy path only" is not acceptable for Normal+ scope.

- Offline / timeout behavior
- Empty state
- Validation failures
- Session expiry (if authenticated)

## Localization

- New user-facing strings? yes/no
- If yes: keys land in all of `app_en.arb`, `app_vi.arb`, `app_ja.arb`

## Out of Scope

Explicitly list what this task will NOT do.

## Validation Plan

Per `docs/ai/VALIDATION_MATRIX.md`: which tests/proof will demonstrate each
acceptance criterion.

## Open Questions

Questions that must be answered by a human before or during implementation.
