#!/usr/bin/env bash
# Run from a consuming site's source directory (the one holding config.toml),
# before `zola build`/`zola serve`. Reads [extra].theme_version from that
# site's config.toml and materializes themes/zola-site directly as either a
# live symlink to this directory ("main", the default) or a materialized
# checkout of a specific version's tag. Nothing under themes/zola-site is ever
# committed -- this script is the only thing that populates it. See README.md.
#
# Everything is resolved relative to this script's own location, not the
# invoking site's -- since ADR-0154 the consuming site lives in a different
# repo, so the library is wherever this copy of the script was fetched to, and
# asking git from the *site's* directory would find the wrong repo.
#
# LIB-0050 moved the theme to tools/static-site/zola/ and its track to
# static-site/zola/vX.Y.Z. A version is looked up on that track first, then on
# zola-site/vX.Y.Z, the track before it, and read from whichever path its tag
# holds. The theme's name in a site's config.toml stays zola-site.
set -euo pipefail

THEME_NAME="zola-site"
THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SITE_DIR="$(pwd)"

VERSION=$(awk '/^\[extra\]/{f=1; next} f && /^theme_version[[:space:]]*=/{print; exit}' config.toml \
  | sed -E 's/^theme_version[[:space:]]*=[[:space:]]*"([^"]*)".*/\1/')
VERSION="${VERSION:-main}"

RESOLVED_DIR="$SITE_DIR/themes/$THEME_NAME"
rm -rf "$RESOLVED_DIR"
mkdir -p "$(dirname "$RESOLVED_DIR")"

if [ "$VERSION" = "main" ]; then
  ln -s "$THEME_DIR" "$RESOLVED_DIR"
  echo "Resolved $THEME_NAME -> main (live symlink)"
else
  TAG=""
  for t in "static-site/zola/v${VERSION#v}" "zola-site/v${VERSION#v}"; do
    if git -C "$THEME_DIR" rev-parse --verify --quiet "$t" >/dev/null; then
      TAG="$t"
      break
    fi
  done
  if [ -z "$TAG" ]; then
    echo "::error::Unknown theme version $VERSION: no static-site/zola/v${VERSION#v} or zola-site/v${VERSION#v} tag" >&2
    exit 1
  fi
  # The theme's path at that tag: tools/static-site/zola/ since LIB-0050,
  # lib/zola-site/ since LIB-0047, zola-site/ before.
  TAG_DIR=""
  for d in tools/static-site/zola lib/zola-site zola-site; do
    if git -C "$THEME_DIR" cat-file -e "${TAG}:${d}/theme.toml" 2>/dev/null; then
      TAG_DIR="$d"
      break
    fi
  done
  if [ -z "$TAG_DIR" ]; then
    echo "::error::$TAG holds no theme" >&2
    exit 1
  fi
  mkdir -p "$RESOLVED_DIR"
  # From the clone's top level: run from a subdirectory, git archive keeps
  # only that subdirectory's part of the tree.
  git -C "$(git -C "$THEME_DIR" rev-parse --show-toplevel)" archive "${TAG}:${TAG_DIR}" | tar -x -C "$RESOLVED_DIR"
  echo "Resolved $THEME_NAME -> $TAG (materialized)"
fi
