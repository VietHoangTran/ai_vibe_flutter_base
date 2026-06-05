#!/usr/bin/env sh
# Doc freshness guard.
#
# Fails when structural source changes (added/deleted/renamed files under
# watched paths) ship without any documentation update. Pure in-place edits
# do not trigger the guard, so bug fixes stay friction-free.
#
# Watched paths:   lib/core/  lib/shared/  tools/  scripts/
# Doc paths:       docs/  AGENTS.md  CLAUDE.md  README.md
#
# Usage:
#   scripts/check_doc_freshness.sh --ci <base_ref>   # diff <base_ref>...HEAD (CI/PR)
#   scripts/check_doc_freshness.sh --local           # uncommitted + untracked changes
set -eu

mode="${1:---local}"

case "$mode" in
  --ci)
    base="${2:?usage: check_doc_freshness.sh --ci <base_ref>}"
    changes=$(git diff --name-status "$base...HEAD")
    ;;
  --local)
    # Staged + unstaged + untracked, normalized to "STATUS<TAB>PATH" lines.
    changes=$(
      git diff HEAD --name-status
      git ls-files --others --exclude-standard | awk '{print "A\t" $0}'
    )
    ;;
  *)
    echo "usage: $0 [--local | --ci <base_ref>]" >&2
    exit 64
    ;;
esac

# Renames are "R<score><TAB>old<TAB>new"; use the new path.
structural=$(printf '%s\n' "$changes" | awk -F'\t' '
  $1 ~ /^(A|D|R)/ {
    path = ($1 ~ /^R/) ? $3 : $2
    if (path ~ /^(lib\/core\/|lib\/shared\/|tools\/|scripts\/)/) print path
  }')

docs_touched=$(printf '%s\n' "$changes" | awk -F'\t' '
  {
    path = ($1 ~ /^R/) ? $3 : $2
    if (path ~ /^docs\//) print path
    if (path == "AGENTS.md" || path == "CLAUDE.md" || path == "README.md") print path
  }')

if [ -n "$structural" ] && [ -z "$docs_touched" ]; then
  {
    echo '[doc-freshness] FAIL: structural source changes without doc updates.'
    echo '[doc-freshness] Added/deleted/renamed files in watched paths:'
    printf '%s\n' "$structural" | sed 's/^/  - /'
    echo '[doc-freshness] Update docs/CODEMAP.md (and AGENTS.md or docs/* as'
    echo '[doc-freshness] relevant), or revert the structural change.'
  } >&2
  exit 1
fi

echo '[doc-freshness] OK'
