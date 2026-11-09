---
title: This documentation site
weight: 10
description: How the site is built, how to preview it, and how versions are published.
---

The site is [Hugo](https://gohugo.io) with the [Docsy](https://www.docsy.dev) theme, pulled in as a Hugo module.

## Preview locally

You need Hugo **extended** 0.160.1 or newer, Go and Node 20.

```bash
npm ci
npm run serve
```

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
