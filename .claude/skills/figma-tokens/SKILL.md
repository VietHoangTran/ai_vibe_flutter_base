---
name: figma-tokens
description: Sync-check design tokens between a Figma file and lib/core/theme, producing a gap report. Use when the user asks to sync tokens, check design consistency, or before building screens from a new Figma file.
---

# /figma-tokens — Token Gap Check

Compare Figma variables/styles against the app's token classes and report
gaps. This is a read-and-report skill: propose token changes, apply only
after approval.

## App token sources

| Kind | Class | File |
| --- | --- | --- |
| Color seed + scaffold colors | `AppTheme` | `lib/core/theme/app_theme.dart` |
| Spacing / sizes | `AppSpacing` | `lib/core/theme/app_spacing.dart` |
| Radius | `AppRadius` | `lib/core/theme/app_spacing.dart` |
| Durations / curves | `AppDurations` | `lib/core/theme/app_durations.dart` |

Colors beyond the seed come from `ColorScheme.fromSeed`; component styling
lives in `AppTheme._build`. Typography comes from the Material text theme.

## Steps

1. **Fetch Figma tokens.** `mcp figma get_variable_defs` on the file/frame
   (plus `get_design_context` if variables are not used and values must be
   sampled from styles).
2. **Read app tokens** from the files above.
3. **Build the gap report** (markdown table in the response):
   - Figma token → matching app token (exact / nearest / missing)
   - App token unused by the design (informational)
   - Conflicts: same-purpose value differs (e.g. Figma radius 16 vs
     `AppRadius.lg` 20)
4. **Recommend per gap:** snap design value to nearest existing token, or
   add a token. Adding/changing a token in `lib/core/theme/` is a structural
   design-system change — get explicit approval, and check impact on existing
   screens (goldens will catch drift).
5. **If changes are approved:** edit the token files, run
   `scripts/quality_check.sh`, update goldens intentionally
   (`flutter test --update-goldens`) only after visually confirming diffs,
   and update `docs/design/COMPONENT_MAP.md` if mappings changed.

## Rules

- Never auto-rewrite `AppTheme`/`AppSpacing` wholesale from Figma; tokens are
  curated, not generated.
- One seed color drives the scheme. A second accent from Figma is a design
  decision for a human, not a silent edit.
