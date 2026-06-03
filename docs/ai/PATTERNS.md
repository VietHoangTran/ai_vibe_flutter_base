# AI Coding Patterns

Use these patterns when extending the base.

## Feature Layout

```text
lib/features/<feature>/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── controllers/
    ├── pages/
    └── widgets/
```

Generate with:

```bash
dart run tools/feature_cli.dart <feature_name>
```

## Data Flow

```text
Page/widget → Riverpod controller → use case → repository interface → repository impl → datasource/API/storage
```

## Riverpod Provider Pattern

```dart
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ProfileRemoteDataSource(ref.watch(dioProvider)));
});
```

## Riverpod Async Controller Pattern

```dart
final profileControllerProvider = FutureProvider<Profile>((ref) {
  final useCase = GetProfileUseCase(ref.watch(profileRepositoryProvider));
  return useCase();
});
```

## Localization Pattern

Add keys to every ARB file under `assets/l10n/`, then use:

```dart
Text(context.l10n.homeTitle)
```

## Routing Pattern

- Put route constants in `lib/core/routing/route_names.dart`.
- Register routes in `lib/core/routing/app_router.dart`.
- Keep page constructors simple.
- Keep auth redirects in router-level redirect logic.

## Network Pattern

- Use `dioProvider`.
- Keep endpoints in datasource or endpoint constants.
- Convert network errors through existing exception mapping.
- Do not mutate global Dio base URL per request.

## Shared Widget Pattern

Reusable UI belongs in `lib/shared/widgets/`.

Prefer shared components for common UI:

- `AppButton`
- `AppTextField`
- `AsyncValueView`
- `DismissKeyboard`
- `showAppSnackBar`
