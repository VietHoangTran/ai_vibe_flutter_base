#!/usr/bin/env sh
# Coverage gate.
#
# Reads coverage/lcov.info (produced by `flutter test --coverage`) and fails
# when line coverage of non-generated lib/ code drops below the threshold.
#
# Generated code is excluded: *.g.dart, *.freezed.dart, lib/core/gen/,
# lib/core/localization/l10n/.
#
# Known limitation: lcov.info only contains files loaded by at least one
# test. Files never imported by any test are invisible to this gate, so the
# real coverage is at most the reported number. Entry points (main.dart,
# bootstrap) and pure abstract interfaces are the usual gaps.
#
# Usage:
#   scripts/check_coverage.sh [min_percent]   # default: $MIN_COVERAGE or 65
#
# Baseline threshold is 65. Ratchet it up as coverage improves; the long-term
# target for business logic (domain + data + controllers) is 80.
set -eu

lcov_file="coverage/lcov.info"
min="${1:-${MIN_COVERAGE:-65}}"

if [ ! -f "$lcov_file" ]; then
  echo "[coverage] FAIL: $lcov_file not found. Run: flutter test --coverage" >&2
  exit 1
fi

result=$(awk -F: '
  /^SF:/ {
    f = $2
    gen = (f ~ /\.g\.dart$/ || f ~ /\.freezed\.dart$/ \
        || f ~ /core\/gen\// || f ~ /core\/localization\/l10n\//)
  }
  /^LF:/ { if (!gen) lf += $2 }
  /^LH:/ { if (!gen) lh += $2 }
  END {
    if (lf == 0) { print "0.0 0 0"; exit }
    printf "%.1f %d %d", lh * 100 / lf, lh, lf
  }' "$lcov_file")

pct=$(printf '%s' "$result" | cut -d' ' -f1)
lh=$(printf '%s' "$result" | cut -d' ' -f2)
lf=$(printf '%s' "$result" | cut -d' ' -f3)

echo "[coverage] non-generated line coverage: ${pct}% (${lh}/${lf} lines, threshold ${min}%)"

ok=$(awk -v p="$pct" -v m="$min" 'BEGIN { print (p >= m) ? 1 : 0 }')
if [ "$ok" -ne 1 ]; then
  echo "[coverage] FAIL: coverage ${pct}% is below threshold ${min}%." >&2
  echo "[coverage] Add tests for the changed code or see docs/development/TESTING.md." >&2
  exit 1
fi

echo '[coverage] OK'
