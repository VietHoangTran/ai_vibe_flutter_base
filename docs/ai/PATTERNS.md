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

Generate with a dry-run first:

```bash
dart run tools/feature_cli.dart <feature_name> --dry-run
dart run tools/feature_cli.dart <feature_name>
```

Use `lib/features/auth/` as the canonical full-layer reference feature. Use
`lib/features/settings/` as the reference for local persistence/preferences.

## Data Flow

```text
Page/widget → Riverpod controller → use case → repository interface → repository impl → datasource/API/storage
```

Do not skip layers for non-trivial feature code.

## Riverpod Repository Provider Pattern

Use Riverpod annotations for dependency wiring:

```dart
@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepositoryImpl(
    ProfileRemoteDataSource(ref.watch(dioProvider)),
  );
}
```

## Riverpod Async Controller Pattern

Controllers own presentation state and call use cases:

```dart
@riverpod
class ProfileController extends _$ProfileController {
  @override
  Future<Profile> build() {
    final useCase = GetProfileUseCase(ref.watch(profileRepositoryProvider));
    return useCase();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final useCase = GetProfileUseCase(ref.read(profileRepositoryProvider));
      return useCase();
    });
  }
}
```

## Use Case Pattern

Use cases keep feature actions explicit and testable:

```dart
class GetProfileUseCase {
  const GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Profile> call() => _repository.getProfile();
}
```

## Repository Pattern

Define contracts in `domain/repositories` and implement them in
`data/repositories`:

```dart
abstract interface class ProfileRepository {
  Future<Profile> getProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Profile> getProfile() async {
    final model = await _remoteDataSource.fetch();
    return model.toEntity();
  }
}
```

## Datasource Pattern

Dio belongs in datasource classes, not widgets/controllers/repositories outside
the data layer:

```dart
class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ProfileModel> fetch() async {
    final response = await _dio.get<Map<String, dynamic>>('/profile');
    final data = response.data;
    if (data == null) {
      throw const FormatException('Missing Profile response body');
    }

    return ProfileModel.fromJson(data);
  }
}
```

## Localization Pattern

Add keys to every ARB file under `assets/l10n/`, run `flutter gen-l10n`, then
use:

```dart
Text(context.l10n.homeTitle)
```

Do not hardcode user-facing app text in completed feature UI.

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
- Do not log sensitive response data.

## Shared Widget Pattern

Reusable UI belongs in `lib/shared/widgets/`.

Prefer shared components for common UI:

- `AppButton`
- `AppTextField`
- `AsyncValueView`
- `DismissKeyboard`
- `showAppSnackBar`
- `Pressable`
- `FadeSlideIn`
- `BrandMark`

## Import Convention

Within a single feature, relative imports are acceptable and match the generated
skeleton. Use package imports when tests or cross-feature/core/shared imports are
clearer.
