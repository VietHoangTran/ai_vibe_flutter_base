#!/usr/bin/env sh
# Claude Code Stop hook: block the session from finishing once when structural
# source changes have no matching doc update. Delegates the actual check to
# scripts/check_doc_freshness.sh so the rule stays identical to CI.
set -eu

input=$(cat)

# When the stop hook already fired in this stop cycle, do not block again,
# otherwise the session could loop forever.
if printf '%s' "$input" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-$(pwd)}"

if ! output=$(scripts/check_doc_freshness.sh --local 2>&1); then
  {
    printf '%s\n' "$output"
    echo 'Structural changes under lib/core/, lib/shared/, tools/, or scripts/'
    echo 'have no matching doc update. Update docs/CODEMAP.md (and AGENTS.md or'
    echo 'docs/* as relevant), then re-run scripts/check_doc_freshness.sh --local.'
    echo 'If no doc change is genuinely needed, state why in the final summary.'
  } >&2
  exit 2
fi

exit 0
