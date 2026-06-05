---
name: spec
description: Turn a raw requirement (text, ticket, Figma link, screenshot) into a reviewed feature spec before any code is written. Use when the user asks to build a feature from a requirement, or types /spec.
---

# /spec — Requirement to Feature Spec

Turn raw input into `docs/specs/<NNNN>-<feature-slug>.md` using
`docs/templates/feature-spec.md`. Do NOT write app code in this skill; the
output is a spec the human approves first.

## Steps

1. **Collect the source.** Accept any of: pasted text, Jira/Confluence link
   (use Atlassian MCP tools if available), Figma link (use Figma MCP
   `get_screenshot` + `get_design_context` for screens referenced), or an
   image.
2. **Classify scope** with `docs/ai/FEATURE_INTAKE.md` (Tiny / Normal /
   High-risk). Tiny → tell the user a spec is overkill and stop unless they
   insist.
3. **Draft the spec** from `docs/templates/feature-spec.md`. Number it
   sequentially after existing files in `docs/specs/` (create the dir if
   missing). Fill every section; mark unknowns as Open Questions instead of
   inventing details.
4. **API involved?** Also draft `docs/specs/<NNNN>-api-contract.md` from
   `docs/templates/api-contract.md`. Never invent field names — mark them as
   open questions if the source doesn't define them.
5. **Ask, don't assume.** If acceptance criteria, error states, or navigation
   outcomes are ambiguous, ask the user (AskUserQuestion) before finalizing.
6. **Hand off.** Present the spec summary and stop. Implementation starts only
   after the human approves, following `docs/ai/TASK_PLAYBOOK.md` ("New
   feature") with the spec as the source of truth.

## Rules

- Acceptance criteria must be testable (Given/When/Then).
- Every screen in scope needs explicit empty/error/offline behavior.
- New user-facing text means all three ARB files (`en`, `vi`, `ja`).
- Out of Scope section is mandatory — it prevents scope drift mid-task.
