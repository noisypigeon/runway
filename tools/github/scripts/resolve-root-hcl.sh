#!/usr/bin/env bash
# Run from a consuming spoke's repo root (the directory holding spoke.hcl).
# Reads root_hcl_version from that spoke.hcl and materializes ./root.hcl from
# github/terragrunt/root.hcl -- either the working-tree copy ("main") or the
# copy at tag github/terragrunt/v<version>, or at terragrunt/root-hcl/v<version>
# for a version cut before LIB-0050 renamed the track. See
# github/terragrunt/README.md and LIB-0003. From v3.0.0 it does the same for
# ./secrets-schema.json, which that root.hcl reads from beside itself
# (LIB-0010); a version without one gets none, and a stale copy is removed.
#
# The spoke commits the result. Terragrunt's [main...HEAD] git filter plans
# every unit inside temporary git worktrees of both refs, so an untracked
# root.hcl does not exist where the plan actually runs -- and the base ref's
# own committed copy is what lets a removed leaf still plan its destroy.
#
# --check writes nothing: it exits 1 unless ./root.hcl and ./secrets-schema.json
# are byte-identical to the pinned template's, which is how CI keeps the
# committed copies honest. Without it, the script (re)writes both, which is how
# a spoke takes a version bump.
#
# Copied, never symlinked: the template locates spoke.hcl through
# get_parent_terragrunt_dir(), and a leaf's path_relative_to_include() -- which
# is the state key (LIB-0001 invariant 4) -- is relative to root.hcl's own
# directory. Both have to be the spoke's root, not the library clone's.
#
# The library root is resolved from this script's own location rather than by
# asking git, for the reason DEV-0154 gave resolve-theme.sh: the copy that runs
# is the one in the spoke's fetched .pigeon/src/, and `git rev-parse` from the
# spoke would find the spoke. Lives under tools/github/scripts/ so the
# github/workflows/ track versions it.
set -euo pipefail

CHECK=false
case "${1:-}" in
  --check) CHECK=true ;;
  "") ;;
  *) echo "usage: $0 [--check]" >&2; exit 2 ;;
esac

LIB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TEMPLATE_DIR="github/terragrunt"
# The template's files, each materialized at the spoke root under its own name.
FILES="root.hcl secrets-schema.json"
SPOKE_DIR="$(pwd)"
# The spoke's config: .config/ when it holds spoke.hcl, else for one version
# more the repo root (LIB-0052 §§1, 3).
CONFIG_DIR="$SPOKE_DIR/.config"
[ -f "$CONFIG_DIR/spoke.hcl" ] || CONFIG_DIR="$SPOKE_DIR"

if [ ! -f "$CONFIG_DIR/spoke.hcl" ]; then
  echo "::error::No spoke.hcl in $SPOKE_DIR/.config or $SPOKE_DIR; run this from the spoke's repo root" >&2
  exit 1
fi

if [ "$SPOKE_DIR" = "$LIB_ROOT" ]; then
  echo "::error::Refusing to materialize root.hcl into the library itself" >&2
  exit 1
fi

VERSION=$(sed -nE 's/^[[:space:]]*root_hcl_version[[:space:]]*=[[:space:]]*"([^"]*)".*/\1/p' "$CONFIG_DIR/spoke.hcl" | head -n1)
if [ -z "$VERSION" ]; then
  echo "::error::spoke.hcl sets no root_hcl_version" >&2
  exit 1
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# Fetch each file the pinned version has into $TMP_DIR. root.hcl is mandatory;
# secrets-schema.json exists from v3.0.0 on.
if [ "$VERSION" = "main" ]; then
  for f in $FILES; do
    if [ -f "$LIB_ROOT/$TEMPLATE_DIR/$f" ]; then
      cp "$LIB_ROOT/$TEMPLATE_DIR/$f" "$TMP_DIR/$f"
    fi
  done
  SOURCE="main (working tree)"
else
  # The new track first, then the one before LIB-0050. Each tag holds its
  # template at its own path: tools/github/terragrunt/ after the rename,
  # lib/terragrunt/root-hcl/ after LIB-0047, terragrunt/root-hcl/ before.
  TAG=""
  for t in "github/terragrunt/v${VERSION#v}" "terragrunt/root-hcl/v${VERSION#v}"; do
    if git -C "$LIB_ROOT" rev-parse --verify --quiet "$t" >/dev/null; then
      TAG="$t"
      break
    fi
  done
  if [ -z "$TAG" ]; then
    echo "::error::Unknown version $VERSION: no github/terragrunt/v${VERSION#v} or terragrunt/root-hcl/v${VERSION#v} tag" >&2
    exit 1
  fi
  TAG_DIR=""
  for d in tools/github/terragrunt lib/terragrunt/root-hcl terragrunt/root-hcl; do
    if git -C "$LIB_ROOT" cat-file -e "${TAG}:${d}/root.hcl" 2>/dev/null; then
      TAG_DIR="$d"
      break
    fi
  done
  for f in $FILES; do
    if [ -n "$TAG_DIR" ] && git -C "$LIB_ROOT" cat-file -e "${TAG}:${TAG_DIR}/$f" 2>/dev/null; then
      git -C "$LIB_ROOT" show "${TAG}:${TAG_DIR}/$f" > "$TMP_DIR/$f"
    fi
  done
  SOURCE="$TAG"
fi

if [ ! -f "$TMP_DIR/root.hcl" ]; then
  echo "::error::$SOURCE has no $TEMPLATE_DIR/root.hcl" >&2
  exit 1
fi

if [ "$CHECK" = true ]; then
  for f in $FILES; do
    if [ ! -f "$TMP_DIR/$f" ]; then
      if [ -e "$CONFIG_DIR/$f" ]; then
        echo "::error::$f is committed but $SOURCE has none; run resolve-root-hcl.sh and commit the result" >&2
        exit 1
      fi
      continue
    fi
    if [ ! -f "$CONFIG_DIR/$f" ]; then
      echo "::error::No committed $f; run resolve-root-hcl.sh and commit the result" >&2
      exit 1
    fi
    if ! cmp -s "$TMP_DIR/$f" "$CONFIG_DIR/$f"; then
      echo "::error::$f differs from $SOURCE; run resolve-root-hcl.sh and commit the result, never edit it by hand" >&2
      exit 1
    fi
    echo "$f matches $SOURCE"
  done
  exit 0
fi

for f in $FILES; do
  if [ -f "$TMP_DIR/$f" ]; then
    cp "$TMP_DIR/$f" "$CONFIG_DIR/$f"
    chmod 644 "$CONFIG_DIR/$f"
    echo "Resolved $f -> $SOURCE"
  elif [ -e "$CONFIG_DIR/$f" ]; then
    rm -f "$CONFIG_DIR/$f"
    echo "Removed $f: $SOURCE has none"
  fi
done
