# Component Map — Figma ↔ Flutter

When implementing UI from a design (Figma or otherwise), consult this map
BEFORE writing any widget. Reuse the mapped widget; do not rebuild an
equivalent one-off. If a design needs a component that does not exist here,
build it once in the right place and add a row.

## Widgets

| Design component (typical Figma name) | Flutter widget | File | Notes |
| --- | --- | --- | --- |
| Primary/secondary button, CTA | `AppButton` | `lib/shared/widgets/app_button.dart` | Variants via constructor, not new widgets |
| Text input, form field | `AppTextField` | `lib/shared/widgets/app_text_field.dart` | Includes error/label states |
| Loading / error / empty state, async content | `AsyncValueView` | `lib/shared/widgets/async_value_view.dart` | Localized default error; pass `onRetry` |
| Toast / snackbar / inline notice | `showAppSnackBar` | `lib/shared/widgets/app_snack_bar.dart` | — |
| Offline indicator | `OfflineBanner` | `lib/shared/widgets/offline_banner.dart` | Already wired globally in `app.dart` |
| Tap feedback wrapper, pressable card | `Pressable` | `lib/shared/widgets/pressable.dart` | Scale/opacity press feedback |
| Entrance animation, fade/slide reveal | `FadeSlideIn` | `lib/shared/widgets/fade_slide_in.dart` | Stagger with `AppDurations.stagger` |
| Logo / brand lockup | `BrandMark` | `lib/shared/widgets/brand_mark.dart` | — |
| Keyboard-dismiss scaffold body | `DismissKeyboard` | `lib/shared/widgets/dismiss_keyboard.dart` | Wrap form pages |
| Settings group/section | `SettingsSection` | `lib/features/settings/presentation/widgets/settings_section.dart` | Feature-local; promote to shared if reused |

## Design tokens

Never hardcode values lifted from a design. Map them to tokens:

| Design value | Token source |
| --- | --- |
| Colors | `Theme.of(context).colorScheme` (seed `AppTheme.seedColor`, `lib/core/theme/app_theme.dart`) |
| Typography | `Theme.of(context).textTheme` |
| Spacing / padding / gaps | `AppSpacing` (`lib/core/theme/app_spacing.dart`) |
| Corner radius | `AppRadius` (`lib/core/theme/app_spacing.dart`) |
| Animation durations / easing | `AppDurations` (`lib/core/theme/app_durations.dart`) |
| Min touch target | `AppSpacing.minTouchTarget` (48) |
| Max content width | `AppSpacing.maxContentWidth` (480) |

If a design uses a value with no matching token, snap to the nearest token.
Only add a new token (in `lib/core/theme/`) when the design system genuinely
introduces a new step — never inline the raw number. Run `/figma-tokens` to
diff Figma variables against these tokens.

## Maintenance

- Adding a widget to `lib/shared/widgets/` → add a row here (doc-freshness
  guard will remind you).
- A feature-local widget reused by a second feature → move it to shared and
  update its row.
