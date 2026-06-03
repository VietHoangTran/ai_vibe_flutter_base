# Environments

The base supports three starter environments:

- `dev`
- `staging`
- `prod`

Configuration is read from Dart defines in `lib/core/config/app_config.dart`.

## Run

Development:

```bash
scripts/flutter_dev.sh
```

Staging:

```bash
scripts/flutter_staging.sh
```

Production:

```bash
scripts/flutter_prod.sh
```

Manual equivalent:

```bash
flutter run --dart-define-from-file=config/staging.json
flutter run --dart-define-from-file=config/prod.json
```

## Build Android

```bash
flutter build apk --release --dart-define-from-file=config/staging.json
flutter build apk --release --dart-define-from-file=config/prod.json
```

## Build iOS

```bash
flutter build ios --release --dart-define-from-file=config/staging.json
flutter build ios --release --dart-define-from-file=config/prod.json
```

## Secrets

The checked-in config files are placeholders for a base project. Do not commit real API keys, tokens, or private endpoints.

For real apps, inject secrets through CI/CD or platform-specific secure config.

## Flavors

This base currently uses Dart define files rather than Android/iOS native flavors. That keeps setup lightweight and works on Android and iOS.

If native flavors are needed later, add them intentionally and keep the same `APP_ENV`, `APP_NAME`, and `API_BASE_URL` keys so Dart code does not change.
