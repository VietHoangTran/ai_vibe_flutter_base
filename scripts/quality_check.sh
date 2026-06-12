#!/usr/bin/env sh
set -eu

printf '\n[quality] flutter pub get\n'
flutter pub get

printf '\n[quality] generate\n'
scripts/generate.sh

printf '\n[quality] dart format check\n'
dart format --set-exit-if-changed .

printf '\n[quality] dart analyze\n'
dart analyze --fatal-infos --fatal-warnings

printf '\n[quality] flutter test (with coverage)\n'
flutter test --coverage

printf '\n[quality] coverage gate\n'
scripts/check_coverage.sh

printf '\n[quality] all checks passed\n'
