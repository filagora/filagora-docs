#!/usr/bin/env bash
# Regenerates the per-package pages from each package's README.md so the docs
# cannot drift from the packages. Run from anywhere; PACKAGES_DIR defaults to
# the directory holding this repository's siblings.
#
#   bash scripts/sync-packages.sh
#   PACKAGES_DIR=~/src/filagora bash scripts/sync-packages.sh
#
# Only public packages are listed. Never add a private repository here.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
packages_dir="${PACKAGES_DIR:-$(cd "$root/.." && pwd)}"
org="https://github.com/filagora"

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
  src="$packages_dir/$repo/README.md"
  if [ ! -f "$src" ]; then
    echo "skip $repo (no README at $src)" >&2
    continue
  fi

  description=""
  if [ -f "$packages_dir/$repo/composer.json" ]; then
    description="$(php -r '$j=json_decode(file_get_contents($argv[1]),true); echo $j["description"] ?? "";' "$packages_dir/$repo/composer.json" 2>/dev/null || true)"
  fi
  version="$(git -C "$packages_dir/$repo" describe --tags --abbrev=0 2>/dev/null || true)"
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
    echo "This page is generated from the package's [README]($org/$repo#readme)${version:+ at \`$version\`}. To change it, edit the README in [\`$repo\`]($org/$repo) and re-run \`scripts/sync-packages.sh\`."
    echo "{{% /pageinfo %}}"
    echo
    # Drop the README's H1 (the page title replaces it) and point relative
    # links at the repository, since they do not resolve on this site.
    awk 'BEGIN{h=0} !h && /^# /{h=1; next} {print}' "$src" \
      | perl -pe 's{\]\((?!https?://|#|mailto:|/)([^)\s]+)\)}{](https://github.com/filagora/'"$repo"'/blob/HEAD/$1)}g'
  } > "$out"
  echo "wrote ${out#$root/}"
done <<< "$manifest"
