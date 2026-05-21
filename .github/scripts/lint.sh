#!/usr/bin/env bash
# Semantic catalog checks: manifest consistency, slug/icon, i18n key resolution.
set -euo pipefail

fail=0

if [ ! -f manifest.json ]; then
  echo "::error::manifest.json missing at repo root"
  exit 1
fi

schema_version=$(jq -r '.schemaVersion' manifest.json)
if [ "$schema_version" != "1" ]; then
  echo "::error file=manifest.json::schemaVersion must be 1 (got $schema_version)"
  fail=1
fi

manifest_apps=$(jq -r '.apps[]' manifest.json | sort -u)
folder_apps=$(for d in */wisp.json; do dirname "$d"; done | sort -u)

if [ "$manifest_apps" != "$folder_apps" ]; then
  echo "::error file=manifest.json::apps array does not match the folders containing a wisp.json"
  diff <(echo "$manifest_apps") <(echo "$folder_apps") || true
  fail=1
fi

while IFS= read -r slug; do
  file="$slug/wisp.json"

  actual_slug=$(jq -r '.slug' "$file")
  if [ "$actual_slug" != "$slug" ]; then
    echo "::error file=$file::slug '$actual_slug' does not match folder name '$slug'"
    fail=1
  fi

  icon=$(jq -r '.icon' "$file")
  if [ ! -f "$slug/$icon" ]; then
    echo "::error file=$file::icon path '$icon' does not resolve to an existing file"
    fail=1
  fi

  default_locale=$(jq -r '.defaultLocale // "en"' "$file")
  i18n_dir="$slug/i18n"
  source_locale_file="$i18n_dir/$default_locale.json"

  referenced_keys=$(jq -r '.. | strings | select(startswith("t:")) | .[2:]' "$file" | sort -u)

  if [ -n "$referenced_keys" ]; then
    if [ ! -f "$source_locale_file" ]; then
      echo "::error file=$file::source locale file '$source_locale_file' missing — referenced t: keys cannot be resolved"
      fail=1
      continue
    fi
    source_keys=$(jq -r 'keys[]' "$source_locale_file" | sort -u)
    while IFS= read -r k; do
      [ -z "$k" ] && continue
      echo "::error file=$source_locale_file::missing key '$k' (referenced as t:$k in $file)"
      fail=1
    done < <(comm -23 <(echo "$referenced_keys") <(echo "$source_keys"))
    while IFS= read -r k; do
      [ -z "$k" ] && continue
      echo "::warning file=$source_locale_file::orphan key '$k' (not referenced by any t: in $file)"
    done < <(comm -13 <(echo "$referenced_keys") <(echo "$source_keys"))
  fi

  shopt -s nullglob
  for locale_file in "$i18n_dir"/*.json; do
    [ "$locale_file" = "$source_locale_file" ] && continue
    locale_keys=$(jq -r 'keys[]' "$locale_file" | sort -u)
    if [ -n "$referenced_keys" ]; then
      while IFS= read -r k; do
        [ -z "$k" ] && continue
        echo "::warning file=$locale_file::missing key '$k' (translation incomplete)"
      done < <(comm -23 <(echo "$referenced_keys") <(echo "$locale_keys"))
    fi
    while IFS= read -r k; do
      [ -z "$k" ] && continue
      echo "::warning file=$locale_file::orphan key '$k' (not referenced by any t: in $file)"
    done < <(comm -13 <(echo "${referenced_keys:-}") <(echo "$locale_keys"))
  done
  shopt -u nullglob
done <<< "$folder_apps"

exit $fail
