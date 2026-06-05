# AI Task Playbook

Use this playbook after reading `AGENTS.md`, `docs/HARNESS.md`, and
`docs/ai/AI_CODING_GUIDE.md`. It is a tactical checklist for common AI coding
workflows.

## Tiny docs-only change

1. Confirm the change is docs-only in `docs/ai/FEATURE_INTAKE.md`.
2. Edit only the requested docs.
3. Do not run app codegen unless docs reference generated APIs.
4. Validate with:

   ```bash
   git diff --check
   ```

5. Final response: files changed, validation, blockers, follow-up.

## New feature

0. For Normal/High-risk scope, start from a spec: use the `/spec` skill to
   produce `docs/specs/<NNNN>-<slug>.md` (and an API contract when an API is
   involved), and get it approved before coding.
1. Classify scope with `docs/ai/FEATURE_INTAKE.md`.
2. Inspect `lib/features/auth/` as the canonical full-layer reference.
3. Inspect `lib/features/settings/` for local persistence/preferences patterns.
4. Run generator dry-run first:

   ```bash
   dart run tools/feature_cli.dart <feature_name> --dry-run
   ```

5. Generate the skeleton, adding guidance flags when useful:

   ```bash
   dart run tools/feature_cli.dart <feature_name> --with-route --with-localization
   ```

6. Replace generated `TODO(<feature>)` items with real domain/API/storage logic.
7. If the feature is navigable: `--with-route` auto-registers the route in
   `route_names.dart` and `app_router.dart` at the `// feature_cli:` anchors,
   so verify the generated entries. Without the flag, add route entries
   manually.
8. Add user-facing strings to all ARB files if UI text is shown.
9. Run codegen when annotations or localization change:

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   flutter gen-l10n
   ```

10. Add tests according to `docs/ai/VALIDATION_MATRIX.md`.
11. Validate with `scripts/quality_check.sh`.

## UI change

1. Keep UI under the feature `presentation/` layer unless it is reusable.
2. Check `docs/design/COMPONENT_MAP.md`, then prefer shared widgets from
   `lib/shared/widgets/` before creating one-offs.
3. Use theme, spacing, and duration tokens from `lib/core/theme/`.
4. Localize user-facing text through `context.l10n`.
5. Add or update widget tests for meaningful states/interactions.
6. Validate with widget tests or a manual UI proof note plus quality gate.

## UI from a Figma design

1. Use the `/figma-screen` skill — it encodes the full pipeline.
2. Fetch screenshot + design context for every state frame, not just the
   happy path.
3. Map every element through `docs/design/COMPONENT_MAP.md`; never inline hex
   colors or raw pixel values from the design.
4. Token missing from `lib/core/theme/`? Run `/figma-tokens` and propose the
   token first.
5. Add a golden test plus the Figma reference screenshot under
   `test/goldens/reference/` (see `test/goldens/README.md`).
6. Optionally verify live with `/run-app` and attach the screenshot.

## API integration

1. Keep Dio usage in a datasource only.
2. Use `dioProvider` from `lib/core/network/dio_provider.dart`.
3. Map DTOs/models to domain entities at the repository boundary.
4. Do not expose transport-only fields to the domain layer.
5. Do not log tokens, credentials, or sensitive response data.
6. Add datasource/repository tests with fakes or mocktail.

## Routing change

1. Add constants in `lib/core/routing/route_names.dart`.
2. Register `GoRoute` entries in `lib/core/routing/app_router.dart`.
3. Keep route builders thin.
4. Keep auth/session redirects in router-level redirect logic.
5. Validate with route tests or a manual navigation proof note.

## Localization change

1. Add the same key to every supported ARB file:
   - `assets/l10n/app_en.arb`
   - `assets/l10n/app_vi.arb`
   - `assets/l10n/app_ja.arb`
2. Run:

   ```bash
   flutter gen-l10n
   ```

3. Use `context.l10n.key` from `lib/core/localization/app_localizations_x.dart`.
4. Do not manually edit generated localization Dart files.

## High-risk change

High-risk examples: auth/session/token handling, secure storage, native config,
dependency upgrades, navigation-wide changes, and cross-feature refactors.

1. Clarify scope before editing if anything is ambiguous.
2. Create a story from `docs/templates/story.md` under `docs/stories/`.
3. Add a decision log from `docs/templates/decision.md` if architecture, stack,
   platform, or dependency policy changes.
4. Add strong validation proof from `docs/ai/VALIDATION_MATRIX.md`.
5. Run `scripts/quality_check.sh` before final response.

## Final response contract

Always include:

- files changed summary
- validation commands run
- blockers, if any
- follow-up needed, if any
