#!/usr/bin/env sh
# PostToolUse hook: format Dart files right after Edit/Write so formatting
# drift never reaches the final quality gate.
#
# Reads the hook JSON from stdin, extracts tool_input.file_path, and runs
# `dart format` when the target is a non-generated .dart file. Exits 0 always:
# formatting is convenience here; scripts/quality_check.sh remains the gate.
set -u

payload=$(cat)

file_path=$(printf '%s' "$payload" | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get("tool_input", {}).get("file_path", ""))
except Exception:
    pass
' 2>/dev/null) || exit 0

case "$file_path" in
  *.g.dart | *.freezed.dart | */l10n/*) exit 0 ;;
  *.dart) ;;
  *) exit 0 ;;
esac

[ -f "$file_path" ] || exit 0
command -v dart >/dev/null 2>&1 || exit 0

dart format "$file_path" >/dev/null 2>&1 || true
exit 0
