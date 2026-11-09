#!/usr/bin/env bash
# Builds `master` at the root of OUT and every origin/release-X.Y branch at
# OUT/vX.Y/, as one deployable tree. Used by CI; needs full git history.
#   SITE_URL=https://filagora.github.io/filagora-docs bash scripts/build-all-versions.sh site
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="$(cd "$root" && mkdir -p "$1" && cd "$1" && pwd)"
site="${SITE_URL:?set SITE_URL}"; site="${site%/}"
work="$(mktemp -d)"

build() { # ref destdir baseurl version archived
  git -C "$root" worktree add --force "$work/$1" "origin/$1" >/dev/null 2>&1 \
    || git -C "$root" worktree add --force "$work/$1" "$1" >/dev/null
  (cd "$work/$1" && npm ci --no-audit --no-fund >/dev/null \
    && SYNC_SOURCE=github bash scripts/sync-packages.sh >/dev/null \
    && HUGO_PARAMS_VERSION="$4" HUGO_PARAMS_ARCHIVED_VERSION="$5" \
       bash scripts/hugo.sh --gc --minify --environment production \
         --baseURL "$3" --destination "$2")
}

build master "$out" "$site/" dev false
for ref in $(git -C "$root" for-each-ref --format='%(refname:short)' 'refs/remotes/origin/release-*' | sed 's|^origin/||'); do
  ver="v${ref#release-}"
  build "$ref" "$out/$ver" "$site/$ver/" "${ref#release-}" true
done
