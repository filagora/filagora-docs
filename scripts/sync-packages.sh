#!/usr/bin/env bash
# Generates the per-package pages from each package's README.md so the docs
# cannot drift from the packages. The generated pages are not committed on
# `master`: CI runs this before every build.
#
#   SYNC_SOURCE=github  (CI, `ddev serve`) the README at each package's latest
#                       release tag (its default branch if it has no release),
#                       over plain HTTPS: needs curl and jq only.
#   SYNC_SOURCE=local   (default) the sibling checkouts in PACKAGES_DIR
#                       (defaults to the directory holding this repository).
#
#   bash scripts/sync-packages.sh
#   SYNC_SOURCE=github bash scripts/sync-packages.sh
#
# A release branch freezes its docs: it commits the generated pages and adds
# content/en/docs/.frozen, which makes this script a no-op there.
#
# Only public packages are listed. Never add a private repository here.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
packages_dir="${PACKAGES_DIR:-$(cd "$root/.." && pwd)}"
source_mode="${SYNC_SOURCE:-local}"
org="https://github.com/filagora"

if [ -e "$root/content/en/docs/.frozen" ]; then
  echo "content/en/docs/.frozen exists: keeping the committed package pages"
  exit 0
fi

# repo|section|weight|title
manifest='
filagora-core|packages|10|Core
filagora-entitlements|packages|20|Entitlements
filagora-forums|packages|30|Forums
filagora-cms|packages|40|CMS
filagora-search|packages|50|Search
filagora-messages|packages|60|Messages
filagora-notifications|packages|70|Notifications
filagora-push|packages|80|Push
filagora-memberships|packages|90|Memberships
filagora-compliance|packages|100|Compliance
filagora-logs|packages|110|Logs
filagora-plugins|packages|120|Plugins
filagora-plugins-security|packages|130|Plugins security
filagora-forum-bugreports|packages|140|Forum bug reports
filagora-ai|packages|150|AI
filagora-ai-forums|packages|160|AI for forums
filagora-zencart|packages|170|Zen Cart profile
filagora-demo|tooling|10|Demo app
filagora-package-skeleton|tooling|20|Package skeleton
filagora-shared|tooling|30|Shared workflows
'

for section in packages tooling; do
  find "$root/content/en/docs/$section" -name '*.md' ! -name '_index.md' -delete
done

while IFS='|' read -r repo section weight title; do
  [ -z "$repo" ] && continue
  readme="$(mktemp)"
  description=""
  version=""
  if [ "$source_mode" = github ]; then
    # Plain HTTPS: no `gh` and no API rate limit. `releases/latest` redirects to
    # the tag page, or to `releases` when the repository has no release.
    final="$(curl -fsSL -o /dev/null -w '%{url_effective}' "$org/$repo/releases/latest" 2>/dev/null)" || final=""
    case "$final" in */releases/tag/*) version="${final##*/releases/tag/}" ;; *) version="" ;; esac
    ref="${version:-HEAD}"
    raw="https://raw.githubusercontent.com/filagora/$repo/$ref"
    if ! curl -fsSL "$raw/README.md" -o "$readme" 2>/dev/null; then
      echo "skip $repo (no README at $ref)" >&2
      continue
    fi
    description="$(curl -fsSL "$raw/composer.json" 2>/dev/null | jq -r '.description // ""' 2>/dev/null || true)"
  else
    src="$packages_dir/$repo/README.md"
    if [ ! -f "$src" ]; then
      echo "skip $repo (no README at $src)" >&2
      continue
    fi
    cp "$src" "$readme"
    [ -f "$packages_dir/$repo/composer.json" ] && description="$(jq -r '.description // ""' "$packages_dir/$repo/composer.json" 2>/dev/null || true)"
    version="$(git -C "$packages_dir/$repo" describe --tags --abbrev=0 2>/dev/null || true)"
  fi
  slug="${repo#filagora-}"
  out="$root/content/en/docs/$section/$slug.md"

  {
    echo "---"
    echo "title: \"$title\""
    echo "linkTitle: \"$title\""
    echo "weight: $weight"
    echo "description: >-"
    echo "  ${description:-$title}"
    echo "params:"
    echo "  repo: $repo"
    [ -n "$version" ] && echo "  package_version: $version"
    echo "---"
    echo
    echo "{{% pageinfo %}}"
    echo "This page is generated from the package's [README]($org/$repo#readme)${version:+ at \`$version\`}. To change it, edit the README in [\`$repo\`]($org/$repo) and the next build picks it up."
    echo "{{% /pageinfo %}}"
    echo
    # Drop the README's H1 (the page title replaces it) and point relative
    # links at the repository, since they do not resolve on this site.
    awk 'BEGIN{h=0} !h && /^# /{h=1; next} {print}' "$readme" \
      | perl -pe 's{\]\((?!https?://|#|mailto:|/)([^)\s]+)\)}{](https://github.com/filagora/'"$repo"'/blob/HEAD/$1)}g'
  } > "$out"
  rm -f "$readme"
  echo "wrote ${out#$root/}"
done <<< "$manifest"
