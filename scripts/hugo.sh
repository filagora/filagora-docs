#!/usr/bin/env bash
# Runs hugo with the Dart Sass binary that `npm ci` installs (Docsy needs it on PATH).
#   bash scripts/hugo.sh server
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
sass="$(find "$root/node_modules" -maxdepth 3 -path '*sass-embedded-*/dart-sass/sass' -type f | head -1)"
[ -n "$sass" ] || { echo "Dart Sass not found: run 'npm ci' first" >&2; exit 1; }
export PATH="$(dirname "$sass"):$PATH"
cd "$root"
exec hugo "$@"
