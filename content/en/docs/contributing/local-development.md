---
title: Local development
weight: 5
description: Check out a package, run its tests, and develop it inside the demo app.
---

Every package is a standalone repository that tests itself with [Orchestra Testbench](https://packages.tools/testbench), so you can work on one without a host application. To see packages working together in a real panel, link them into the demo app.

## Requirements

- PHP 8.4 and Composer
- MariaDB (CI uses 11.4). Tests never run on SQLite, so FULLTEXT, `ONLY_FULL_GROUP_BY` and collation behave as in production
- [DDEV](https://ddev.readthedocs.io), recommended: every package and the demo ship a `.ddev/` project that provides PHP and the databases

## Work on one package

```bash
git clone https://github.com/filagora/filagora-core.git
cd filagora-core
ddev start                      # creates the `db` and `testing` databases
ddev composer install
ddev exec vendor/bin/pest
```

If the `testing` database is missing after the first start, run `ddev restart` once.

Without DDEV, run `composer install` on the host and point Pest at your MariaDB through environment variables (`DB_HOST`, `DB_PORT`, `DB_USERNAME`, `DB_PASSWORD`). The database name is fixed to `testing` and is forced by `phpunit.xml.dist`, so your development database is never touched. Create it once yourself:

```sql
CREATE DATABASE testing;
```

Some packages need a service for part of their suite. For example `filagora-search` can test against Meilisearch, which CI starts for you; check the package's README.

### The checks

Run all three before you open a pull request. CI runs the same.

| Command | Runs |
| --- | --- |
| `composer test` | Pest |
| `composer lint` | Pint (formatting) |
| `composer analyse` | Larastan (static analysis) |

With DDEV, prefix each with `ddev` (`ddev composer test`). To run part of the suite:

```bash
ddev exec vendor/bin/pest --filter="name of a test"
ddev exec vendor/bin/pest tests/Feature/SomeTest.php
```

For packages that add Filament screens or commands, also run `php artisan filagora:doctor` from the demo app (below), which checks the installed set is consistent.

## Develop packages inside the demo app

[`filagora-demo`](https://github.com/filagora/filagora-demo) is a Laravel 13 and Filament 5 app that installs the packages. Use it to try a change in a real panel with seeded data.

1. Clone the demo and the packages you will touch **side by side**:

   ```
   filagora/
     filagora-core/
     filagora-forums/
     filagora-demo/
   ```

2. Set the demo up:

   ```bash
   cd filagora-demo
   ddev start
   ddev composer install
   cp .env.example .env
   ddev exec php artisan key:generate
   ddev exec php artisan migrate --seed
   ```

   Open `https://filagora-demo.ddev.site/admin` and sign in as `admin@example.test` with the password `password`. These credentials are public and the demo must never be deployed.

3. Link your checkouts:

   ```bash
   bin/dev-link     # vendor/filagora/* now symlinks to your checkouts
   bin/dev-unlink   # restores the committed composer.json and composer.lock
   ```

   `bin/dev-link` edits `composer.json` and `composer.lock`. Do not commit them in that state: run `bin/dev-unlink` first.

Edits in a package checkout then show up in the running demo immediately. Run the demo's own checks with `ddev exec vendor/bin/pest`, `ddev exec vendor/bin/pint` and `ddev exec php artisan filagora:doctor`.

## Open a pull request

1. Branch from `master`; it is protected.
2. Add tests: every behaviour change needs them, and every bug fix needs a regression test that fails without the fix.
3. Run `composer test`, `composer lint` and `composer analyse`.
4. Update `CHANGELOG.md` for user-visible changes.
5. Open the PR. It is squash-merged once CI (tests, lint and the leak scan) is green.

New to the conventions? Read [Conventions]({{< relref "/docs/concepts/conventions" >}}) first, in particular the table prefix, the user model and `env()` only in config files.
