#!/usr/bin/env bash
# Deletes the run comments that carry Terraform's output (LIB-0054 §5): every
# comment github-actions[bot] posted with a `<!-- terragrunt-… -->` marker and
# a code fence, which is each detail comment and each comment from before
# LIB-0026 split them out. The summaries, which hold only leaf paths, counts
# and links, have no fence and are kept.
#
# It deletes rather than edits, because an edited comment keeps its old text
# in its public history. It prints counts only, never what a comment held.
#
#   scrub-run-comments.sh [--dry-run] owner/repo
#   scrub-run-comments.sh --select < comments.json   # the selection alone
#
# Needs gh, signed in with a token that may delete the repo's issue comments
# (GITHUB_TOKEN with `pull-requests: write` and `issues: write`).
set -euo pipefail

# The comments to delete, from an array of issue comments, as their IDs.
SELECT='.[] | select(.user.login == "github-actions[bot]")
  | select(.body | test("<!-- terragrunt-[a-z]+ -->"))
  | select(.body | contains("```"))
  | .id'

if [ "${1:-}" = "--select" ]; then
  jq -r "$SELECT"
  exit 0
fi

dry_run=false
if [ "${1:-}" = "--dry-run" ]; then
  dry_run=true
  shift
fi
repo="${1:?usage: scrub-run-comments.sh [--dry-run] owner/repo}"

ids=$(gh api --paginate "repos/$repo/issues/comments?per_page=100" | jq -s 'add // []' | jq -r "$SELECT")
total=$(printf '%s' "$ids" | grep -c . || true)
echo "Run comments carrying Terraform output: $total"
if $dry_run; then
  echo "Dry run: nothing deleted."
  exit 0
fi

deleted=0
failed=0
for id in $ids; do
  if gh api -X DELETE "repos/$repo/issues/comments/$id" --silent; then
    deleted=$((deleted + 1))
  else
    failed=$((failed + 1))
  fi
done
echo "Deleted: $deleted. Failed: $failed."
[ "$failed" -eq 0 ]
