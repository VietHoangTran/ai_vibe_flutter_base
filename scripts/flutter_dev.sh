#!/usr/bin/env sh
set -eu

scripts/flutter_env.sh env/.env.dev run "$@"
