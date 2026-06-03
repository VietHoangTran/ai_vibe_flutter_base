# Routing

This base uses GoRouter.

## Files

- Route constants: `lib/core/routing/route_names.dart`
- Router config: `lib/core/routing/app_router.dart`

## Rules

- Keep route definitions centralized.
- Keep page constructors simple.
- Keep auth redirect logic at router level.
- Avoid hardcoding route paths throughout UI code.
- Add localization for user-facing route error text.

## Adding a Route

1. Add path/name in `route_names.dart`.
2. Register route in `app_router.dart`.
3. Add page under the feature presentation layer.
4. Add validation proof or manual navigation note.
