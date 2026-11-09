---
title: Conventions
weight: 20
description: Namespaces, config, tables, user model, models and versioning rules every package follows.
---

## Namespaces and plugins

Each package has a root namespace (`Filagora\Core\`, `Filagora\Forums\`, ...) and one Filament plugin class, for example `Filagora\Core\FilagoraCorePlugin`, that is registered on any host panel. A host chooses its modules, and navigation groups are configurable.

## Configuration

- One config file per package (`config/filagora.php`, `config/filagora-entitlements.php`, ...), merged with the host's copy. List only what differs.
- `env()` appears **only** in config files, and config holds no closures, because closures break `config:cache`. Behaviour that needs code goes through a registry.
- Environment variables are prefixed `FILAGORA_`.

## Tables and the prefix

Every table name goes through `Tables::name('forums')`, which applies the prefix (`filagora_` by default). Always use it in migrations and models. Set the prefix before migrating. An empty prefix uses the bare table names, which is how an existing database adopts the packages with `filagora:adopt`.

## The user model

The host's user model is configurable (`user_model`) and Filagora never alters your `users` table. Create user foreign-key columns through `UserKey::column()` so any future change to key type is local. In `0.x` only bigint keys are supported. Show a different attribute in selects and labels with `user_title_attribute`.

## Swappable models

Packages never hard-code a model class. The `models` config map swaps one by key:

```php
'models' => ['setting' => App\Models\Setting::class],
```

## Public API and versions

Documented contracts, config keys, events and registries are covered by SemVer; everything else is `@internal`. Packages are `0.x` while the API settles and version independently: a package's minor changes when it changes shape, and dependants constrain the minor they need.

## Tests

Tests run on a real MariaDB database named `testing`, never SQLite and never your development database. Every behaviour change ships with tests and every bug fix with a regression test that fails before the fix.
