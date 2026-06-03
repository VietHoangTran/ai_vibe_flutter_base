#!/usr/bin/env sh
set -eu

flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
