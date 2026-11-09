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
- `content/en/docs/packages/` and `tooling/` are **generated from each package's README**. Do not edit them: change the README in the package, then run

  ```bash
  bash scripts/sync-packages.sh      # PACKAGES_DIR defaults to this repo's siblings
  ```

  and commit the result. This keeps the reference from drifting from the code. Add a package by adding a line to the manifest in the script (public repositories only).

## Versions

Docsy's version menu links to separately built copies of the site. CI does this:

| Source | Published at | Banner |
| --- | --- | --- |
| `master` | `/` (development) | none |
| branch `release-<major>.<minor>` | `/v<major>.<minor>/` | "archived snapshot" |

To cut a docs version when a Filagora release set ships: create `release-0.3` from `master`, add an entry to `params.versions` in `hugo.yaml` on `master`, and push. Later changes to a release's docs go on its branch. The build passes `HUGO_PARAMS_VERSION` and `HUGO_PARAMS_ARCHIVED_VERSION` for each branch, so no per-branch config edits are needed.
