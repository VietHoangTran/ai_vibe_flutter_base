#!/usr/bin/env sh
set -eu

flutter run --dart-define-from-file=config/prod.json "$@"
