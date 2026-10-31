#!/usr/bin/env bash
# Prints the newest released version (X.Y.Z) of the unit at <dir>, a path
# under tools/ that is also its tag track, or nothing if it has none. Run from
# tools/. A unit with no tags of its own yet, because it was renamed, continues
# the track its CHANGELOG.md names in a "<!-- continues-from: <tag> -->" line
# (LIB-0020 §4 for modules, LIB-0050 §2 for every track). The named tag must
# exist, so a typo fails here instead of cutting a wrong version.
set -euo pipefail

dir="${1:?usage: latest-version.sh <dir>}"

latest="$(git tag -l "${dir}/v*" | sed "s#^${dir}/v##" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n1 || true)"
if [ -z "$latest" ] && [ -f "${dir}/CHANGELOG.md" ]; then
  from="$(sed -nE 's/^<!-- continues-from: ([a-z0-9/-]+\/v[0-9]+\.[0-9]+\.[0-9]+) -->$/\1/p' "${dir}/CHANGELOG.md" | head -n1)"
  if [ -n "$from" ]; then
    if ! git rev-parse -q --verify "refs/tags/${from}" >/dev/null; then
      echo "::error::${dir}/CHANGELOG.md continues from ${from}, which is not a tag" >&2
      exit 1
    fi
    latest="${from##*/v}"
  fi
fi
echo "$latest"
