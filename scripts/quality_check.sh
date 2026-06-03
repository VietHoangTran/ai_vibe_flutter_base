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

printf '\n[quality] flutter test\n'
flutter test

printf '\n[quality] all checks passed\n'
