# AI Completion Checklist

Before final response, verify:

- [ ] I understood the requested scope.
- [ ] I classified the task as tiny, normal, or high-risk.
- [ ] I followed existing architecture and naming patterns.
- [ ] I inspected `lib/features/auth/` for full-layer feature patterns when relevant.
- [ ] I used `tools/feature_cli.dart` for new feature skeletons.
- [ ] I ran the feature generator with `--dry-run` before creating a new feature.
- [ ] I checked and resolved generated `TODO(<feature>)` items for completed work.
- [ ] I did not introduce GetX, GetIt, BLoC, another router, or another HTTP client.
- [ ] I did not edit generated files manually.
- [ ] I did not hardcode user-facing strings when localization is appropriate.
- [ ] I updated all supported ARB files when adding localized strings.
- [ ] I added or updated tests when behavior changed.
- [ ] I updated docs when adding conventions, tools, scripts, or architecture choices.
- [ ] I ran `scripts/check_doc_freshness.sh --local` if I added, deleted, or renamed files under `lib/core/`, `lib/shared/`, `tools/`, or `scripts/`.
- [ ] I updated the canonical read order in `AGENTS.md` if adding or renaming AI docs.
- [ ] I ran `scripts/quality_check.sh` or documented the blocker.
- [ ] I created a story/decision file if the task required it.
- [ ] My final summary lists files changed, validation, blockers, and follow-up.
