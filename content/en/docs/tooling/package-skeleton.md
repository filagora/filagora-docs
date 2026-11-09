---
title: "Package skeleton"
linkTitle: "Package skeleton"
weight: 20
description: >-
  Template for Filagora packages.
params:
  repo: filagora-package-skeleton
---

{{% pageinfo %}}
This page is generated from the package's [README](https://github.com/filagora/filagora-package-skeleton#readme). To change it, edit the README in [`filagora-package-skeleton`](https://github.com/filagora/filagora-package-skeleton) and re-run `scripts/sync-packages.sh`.
{{% /pageinfo %}}


Template for Filagora packages: a Laravel 13 / Filament 5 plugin with Pest tests,
Larastan, Pint and shared CI. It is not a package to install; copy it to start a new one.

## Creating a package from this template

1. **Copy the tracked files** into the new, empty repository, using the list git gives you
   (replace `../new-package` with its path):

   ```bash
   git ls-files -z | xargs -0 cp --parents -t ../new-package
   ```

   Do not archive or sync the directory: `git archive` honours the export-ignore rules and
   drops `.ddev`, `.github` and `tests`, and copying the directory also copies untracked local
   files such as DDEV's TLS certificates. Then replace the copied `README.md` with your own.
2. **Rename the placeholders**: the `Filagora\Example` namespace, `PackageServiceProvider`,
   `PackagePlugin`, `config/filagora-example.php`, the plugin id, the `FILAGORA_EXAMPLE_`
   environment prefix, the Composer name (`filagora/filagora-example`) and the DDEV project name
   in `.ddev/config.yaml`. Add the packages it depends on to `composer.json`.
3. **Start DDEV**: `ddev start`, then `ddev restart` once (the hook that creates the `testing`
   database only runs on a restart of a newly configured project), then `ddev composer install`.
4. **Add the `LEAK_PATTERNS` secret** to the new repository (CI's leak scan reads it).
5. **Push the first commit** to `master`, wait for CI to go green, then protect `master`: pull
   request required, the CI checks required, no force-push or deletion, squash merges only.
6. **Release**: add a `## [x.y.z] - date` section to `CHANGELOG.md`, tag `vx.y.z` (the tag
   creates the GitHub release), then submit the repository to Packagist.

## Install

```bash
composer require filagora/filagora-example
php artisan vendor:publish --tag=filagora-example-config
```

(Placeholders: replace the package name, tag and class with your own.)

Register the plugin on a Filament panel:

```php
->plugin(\Filagora\Example\PackagePlugin::make())
```

## Configuration

`config/filagora-example.php` is merged with the host's copy, so list only what
differs. Environment variables are prefixed `FILAGORA_`.

## Extending

Extend through documented contracts, events and registries. Anything not documented
is `@internal`.

## Testing

```bash
composer test
```

Tests run against a real MariaDB, never SQLite, so engine behaviour (FULLTEXT,
`ONLY_FULL_GROUP_BY`, collation) matches production. Host and credentials come from
your environment; the database is always named `testing`, never your development one.

## Local development (DDEV)

`.ddev/` is included. `ddev start` creates both `db` and `testing`; give each copy of
this template its own `name` in `.ddev/config.yaml`.

## Licence

MIT. See [LICENSE](https://github.com/filagora/filagora-package-skeleton/blob/HEAD/LICENSE).
