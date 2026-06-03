# Environments

The base supports three starter environments:

- `dev`
- `staging`
- `prod`

Configuration is stored in env files and passed to Flutter as compile-time `--dart-define` values by `scripts/flutter_env.sh`.

## Why env files instead of JSON define files?

Env files are easier to manage in local development and CI/CD secrets workflows. They are also easier to keep out of Git.

This base does **not** load env files at runtime and does **not** bundle env files as assets. The script reads an env file locally and converts each key into `--dart-define=KEY=value`.

That means:

- env files with real values can stay ignored
- Dart code still uses `String.fromEnvironment`
- no `flutter_dotenv` runtime dependency is required

Important: `--dart-define` values are compiled into the mobile app. Do not put server-only secrets, private keys, or admin tokens in mobile env files.

## Files

Committed:

```text
env/.env.example
env/.env.dev
```

Ignored:

```text
env/.env.staging
env/.env.prod
env/.env.local
```

## Create staging/prod env files

```bash
cp env/.env.example env/.env.staging
cp env/.env.example env/.env.prod
```

Then edit values locally.

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
scripts/flutter_env.sh env/.env.staging run
scripts/flutter_env.sh env/.env.prod run
```

## Build Android

```bash
scripts/flutter_env.sh env/.env.staging build apk --release
scripts/flutter_env.sh env/.env.prod build apk --release
```

## Build iOS

```bash
scripts/flutter_env.sh env/.env.staging build ios --release
scripts/flutter_env.sh env/.env.prod build ios --release
```

## CI/CD

In CI, create env files from secrets before building:

```bash
cat > env/.env.staging <<EOF
APP_ENV=staging
APP_NAME=AI Vibe Flutter Base Staging
API_BASE_URL=$STAGING_API_BASE_URL
EOF

scripts/flutter_env.sh env/.env.staging build apk --release
```

## Adding a new config key

When adding a new key:

1. Add default access in `lib/core/config/app_config.dart`.
2. Add the key to `env/.env.example`.
3. Add the key to `env/.env.dev` if needed.
4. Update CI secret/env creation if staging/prod needs it.
5. Document whether the value is safe to embed in a mobile app.

## Native flavors

This base currently uses env-driven Dart defines rather than Android/iOS native flavors. That keeps setup lightweight and works on Android and iOS.

If native flavors are needed later, add them intentionally and keep the same `APP_ENV`, `APP_NAME`, and `API_BASE_URL` keys so Dart code does not change.
