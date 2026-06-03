# AI Coding Prompts

Copy these prompts when using Claude Code or another coding agent.

## Feature Implementation Prompt

```text
You are working in AI Vibe Flutter Base.

Before coding:
1. Read AGENTS.md.
2. Read docs/ai/AI_CODING_GUIDE.md.
3. Read docs/ai/FEATURE_INTAKE.md.
4. Inspect the closest existing feature pattern.

Task:
<describe task>

Rules:
- Use Riverpod, GoRouter, Dio, and feature-first Clean Architecture.
- Do not introduce GetX/GetIt/BLoC unless explicitly approved.
- Use localization for user-facing strings.
- Add/update tests when behavior changes.
- Run scripts/quality_check.sh or report the blocker.
- Summarize files changed and validation proof.
```

## Bug Fix Prompt

```text
You are fixing a bug in AI Vibe Flutter Base.

First:
- Reproduce or identify the failing behavior.
- Locate the smallest affected layer.
- Avoid broad refactors.

Then:
- Patch the minimal code.
- Add/update a regression test when possible.
- Run scripts/quality_check.sh or report blocker.
```

## High-risk Change Prompt

```text
This is a high-risk change.

Before implementation:
- Create a story under docs/stories/ from docs/templates/story.md.
- Identify affected layers and out-of-scope items.
- Ask for missing decisions.

After implementation:
- Add decision log if architecture/security/platform policy changed.
- Provide validation proof from docs/ai/VALIDATION_MATRIX.md.
```
