#!/usr/bin/env bash
# Fail if a PR changes an app.json without bumping its version field.
set -euo pipefail

base_ref="${BASE_SHA:?BASE_SHA env var required}"

# Ensure the base commit is fetched (checkout@v4 with fetch-depth: 0 covers most cases).
git cat-file -e "$base_ref" 2>/dev/null || git fetch --no-tags origin "$base_ref"

changed=$(git diff --name-only "$base_ref" HEAD -- 'apps/*/app.json' | sort -u)

if [ -z "$changed" ]; then
  echo "no app.json changes — skipping version-bump check"
  exit 0
fi

fail=0
while IFS= read -r file; do
  [ -f "$file" ] || continue

  if ! git show "$base_ref:$file" > /tmp/base.json 2>/dev/null; then
    echo "::notice file=$file::new manifest (no base to compare)"
    continue
  fi

  if diff -q <(jq -S 'del(.version)' /tmp/base.json) <(jq -S 'del(.version)' "$file") > /dev/null; then
    continue
  fi

  base_version=$(jq -r '.version' /tmp/base.json)
  head_version=$(jq -r '.version' "$file")
  if [ "$base_version" = "$head_version" ]; then
    echo "::error file=$file::version not bumped (still $head_version) despite content change"
    fail=1
  fi
done <<< "$changed"

exit $fail
