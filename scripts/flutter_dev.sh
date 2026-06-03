#!/usr/bin/env sh
set -eu

flutter run --dart-define=APP_ENV=dev --dart-define=APP_NAME="AI Vibe Flutter Base Dev" --dart-define=API_BASE_URL=https://dev-api.example.com "$@"
