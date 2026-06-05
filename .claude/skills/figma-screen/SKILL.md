---
name: figma-screen
description: Implement a Flutter screen or widget from a Figma link using the project's design tokens, shared widgets, and Clean Architecture. Use whenever the user provides a Figma URL or asks to build UI from a design.
---

# /figma-screen — Figma to Flutter Screen

Standard pipeline for turning a Figma frame into a production screen in this
base. Follow the steps in order; do not freestyle the UI.

## Steps

### 1. Read the design

- `mcp figma get_screenshot` — visual reference for the frame.
- `mcp figma get_design_context` — structure, text, components, variables.
- If multiple frames/states exist (loading, error, empty, filled), fetch all
  of them. A screen is not done with only the happy-path frame.

### 2. Map before coding (mandatory)

- Open `docs/design/COMPONENT_MAP.md`.
- For each element in the design, decide: existing shared widget | existing
  feature widget | genuinely new widget.
- Map every color/spacing/radius/typography value to tokens per the map's
  token table. NEVER inline hex colors or raw pixel values from Figma.
- Token missing? Run the `/figma-tokens` gap check and propose the token
  addition first.

### 3. Scaffold per architecture

- New feature → `dart run tools/feature_cli.dart <name> --dry-run`, then
  generate with `--with-route --with-localization` as appropriate.
- Existing feature → add the page/widgets under that feature's
  `presentation/`.
- Screen state comes from a Riverpod controller; wrap async data in
  `AsyncValueView`.

### 4. Content

- All visible text goes through `context.l10n.*` — add keys to
  `app_en.arb`, `app_vi.arb`, `app_ja.arb`, then `flutter gen-l10n`.
- Export image assets via `mcp figma` asset tools into `assets/images/`,
  then run build_runner for FlutterGen references.

### 5. Verify against the design

- Widget test for meaningful states (per `docs/ai/VALIDATION_MATRIX.md`).
- Golden test for the screen: see `test/goldens/README.md`. Save the Figma
  screenshot to `test/goldens/reference/<screen>.png` so reviewers can diff
  golden vs design.
- Optionally `/run-app` to capture a live screenshot.

### 6. Quality gate

- `scripts/quality_check.sh` before the final response.

## Hard rules

- Shared widgets and tokens first; one-off styling is a review defect.
- No `Color(0xFF...)`, no magic paddings, no inline `TextStyle` font sizes
  lifted from Figma — go through theme/tokens.
- Loading, error, empty, and offline states are part of the screen, even if
  the Figma file omits them (use `AsyncValueView` defaults).
- Mobile-only: validate layout at narrow widths; respect
  `AppSpacing.maxContentWidth` on large phones/foldables.
