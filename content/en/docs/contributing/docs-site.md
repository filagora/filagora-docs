---
title: This documentation site
weight: 10
description: How the site is built, how to preview it, and how versions are published.
---

The site is [Hugo](https://gohugo.io) with the [Docsy](https://www.docsy.dev) theme, pulled in as a Hugo module.

## Prerequisites

| Tool | Version | Why |
| --- | --- | --- |
| Hugo **extended** | 0.160.1 or newer (CI uses 0.169.0) | Builds the site. The extended edition is required to compile the theme's Sass |
| Go | 1.24 or newer | Hugo uses it to download the Docsy theme as a module |
| Node.js and npm | 20 | Installs Bootstrap, Font Awesome and Dart Sass (`npm ci`) |
| Git | any | Hugo reads page history for "last modified" dates |

### Install Hugo

Install the **extended** edition and check it with `hugo version`: the output must say `+extended`, and the version must be at least 0.160.1. Distribution packages are often far older than this (Debian's `apt install hugo` is a 0.1xx release from years ago), so do not use `apt` or an old `snap`.

- **macOS:** `brew install hugo` (the Homebrew build is extended).
- **Windows:** `winget install Hugo.Hugo.Extended`, or `choco install hugo-extended`.
- **Linux:** download `hugo_extended_<version>_linux-amd64.tar.gz` from the [Hugo releases page](https://github.com/gohugoio/hugo/releases), extract the `hugo` binary and put it on your `PATH`, for example:

  ```bash
  tar xzf hugo_extended_0.169.0_linux-amd64.tar.gz hugo
  mv hugo ~/.local/bin/        # make sure ~/.local/bin is on your PATH
  hugo version                 # ... +extended
  ```

Go: `go version`, and install from [go.dev/dl](https://go.dev/dl/) if it is missing or older than 1.24.

## Preview locally

```bash
npm ci               # once, and after package.json changes
npm run serve        # then open http://localhost:1313/filagora-docs/
```

### Why `npm run serve` and not `hugo server`?

Docsy compiles its CSS with **Dart Sass**, and Hugo only finds it if a `sass` executable is on your `PATH`. `npm ci` installs one (the `sass-embedded` package), but inside `node_modules`, where Hugo does not look. `npm run serve` runs `scripts/hugo.sh`, which locates that binary, adds it to `PATH` and then runs `hugo server`. Nothing else is different, and the same wrapper builds the site in CI.

If you already have Dart Sass installed system-wide (`brew install sass/sass/sass`, or a release from the [Dart Sass repository](https://github.com/sass/dart-sass/releases) on your `PATH`), plain `hugo server` works and you can ignore the wrapper. A failure such as `TOCSS-DART: failed to transform "/scss/main.scss"` means Hugo cannot find Dart Sass: use `npm run serve`.

## What is written by hand and what is generated

- `content/en/docs/concepts/`, `getting-started/` and `contributing/` are hand-written. Edit them directly.
- `content/en/docs/packages/` and `tooling/` are **generated from each package's README** and are not committed on `master`. CI runs `scripts/sync-packages.sh` before every build, fetching the README at each package's latest release tag, so a package's docs update when it is released. A daily scheduled build also picks up changes. Do not edit these pages: change the README in the package.

  To preview locally, run `bash scripts/sync-packages.sh` (reads the sibling checkouts) or `SYNC_SOURCE=github bash scripts/sync-packages.sh`. Add a package by adding a line to the manifest in the script (public repositories only).

## Versions

Docsy's version menu links to separately built copies of the site. CI does this:

| Source | Published at | Banner |
| --- | --- | --- |
| `master` | `/` (development) | none |
| branch `release-<major>.<minor>` | `/v<major>.<minor>/` | "archived snapshot" |

To cut a docs version when a Filagora release set ships: create `release-0.3` from `master`, add an entry to `params.versions` in `hugo.yaml` on `master`, and push. Later changes to a release's docs go on its branch.

A release branch is a frozen snapshot, so on that branch run the sync once, commit the generated pages, and add an empty `content/en/docs/.frozen` file (and remove the generated-pages entries from `.gitignore`). The sync is then a no-op there and the old version does not change when a README does. The build passes `HUGO_PARAMS_VERSION` and `HUGO_PARAMS_ARCHIVED_VERSION` for each branch, so no per-branch config edits are needed.
