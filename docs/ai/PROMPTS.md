# AI Coding Prompts

Copy these prompts when using Claude Code or another coding agent.

## Feature Implementation Prompt

```text
You are working in AI Vibe Flutter Base.

Before coding:
1. Read AGENTS.md.
2. Read docs/ai/AI_CODING_GUIDE.md.
3. Read docs/ai/TASK_PLAYBOOK.md.
4. Read docs/ai/FEATURE_INTAKE.md.
5. Inspect lib/features/auth/ as the canonical full-layer reference.

Task:
<describe task>

Rules:
- Use Riverpod annotations, GoRouter, Dio, and feature-first Clean Architecture.
- Run dart run tools/feature_cli.dart <feature_name> --dry-run before creating a new feature.
- Use localization for user-facing strings.
- Add/update tests when behavior changes.
- Run scripts/quality_check.sh or report the blocker.
- Summarize files changed, validation proof, blockers, and follow-up.
```

## New Feature Prompt

```text
Create a new feature named <feature_name>.

Required workflow:
1. Run dart run tools/feature_cli.dart <feature_name> --dry-run.
2. Generate the skeleton with guidance flags if useful:
   dart run tools/feature_cli.dart <feature_name> --with-route --with-localization
3. Replace generated TODO(<feature_name>) items with real logic.
4. If navigable: verify the route auto-registered by --with-route, or add
   route constants and GoRoute manually when the flag was not used.
5. Add all user-facing strings to app_en.arb, app_vi.arb, and app_ja.arb.
6. Add tests according to docs/ai/VALIDATION_MATRIX.md.
7. Run scripts/quality_check.sh.
```

## UI Change Prompt

```text
Improve the UI for <screen/widget>.

Rules:
- Keep screen-specific widgets under the feature presentation layer.
- Move reusable widgets to lib/shared/widgets/ only when reused.
- Use core theme spacing/duration tokens where possible.
- Localize user-facing strings through context.l10n.
- Add or update widget tests for meaningful states/interactions.
- Validate with scripts/quality_check.sh or report blocker.
```

## API Integration Prompt

```text
Integrate API behavior for <feature/action>.

Rules:
- Keep Dio calls inside data/datasources only.
- Use dioProvider from lib/core/network/dio_provider.dart.
- Parse DTOs/models in data/models or datasource layer.
- Map DTOs to domain entities in the repository implementation.
- Keep domain entities free from transport-only fields.
- Add datasource/repository tests with fakes or mocktail.
- Do not log sensitive data.
```

## Routing Prompt

```text
Add navigation for <feature/page>.

Rules:
- Add names/paths in lib/core/routing/route_names.dart.
- Register GoRoute in lib/core/routing/app_router.dart.
- Keep route builders thin.
- Keep auth redirect logic in router-level redirect logic.
- Validate with a route test or manual navigation proof note.
```

## Localization Prompt

```text
Localize user-facing text for <feature/screen>.

Rules:
- Add keys to assets/l10n/app_en.arb, app_vi.arb, and app_ja.arb.
- Run flutter gen-l10n.
- Use context.l10n.<key> from app_localizations_x.dart.
- Do not manually edit generated localization Dart files.
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
- Run scripts/quality_check.sh or report blocker.
```
