---
title: Getting started
weight: 10
description: Install the packages on a Laravel and Filament host, or run the demo app.
---

## Requirements

PHP 8.4, Laravel 13 and Filament 5. The packages are tested against MariaDB 11.4 (never SQLite), so engine behaviour such as FULLTEXT, `ONLY_FULL_GROUP_BY` and collation matches production.

## Install a package

Start with core, then add what you need. Each package's page lists its own steps.

```bash
composer require filagora/filagora-core
php artisan filagora:install   # publishes config, migrates, runs filagora:doctor
```

Register the plugins on a Filament panel:

```php
->plugins([
    \Filagora\Core\FilagoraCorePlugin::make(),
    // add each installed package's plugin here
])
```

Constraints name the minor they need, for example `filagora/filagora-core ^0.2.2`, which in `0.x` means that minor only. Check what you have installed is consistent at any time:

```bash
php artisan filagora:doctor
```

## Try it first: the demo app

[`filagora-demo`](https://github.com/filagora/filagora-demo) is a clean Laravel 13 and Filament 5 application that installs the packages. It is the quickest way to see them working together, and the place to develop a package alongside a host. See [Demo app]({{< relref "/docs/tooling/demo" >}}).

## Next

- Read [Architecture]({{< relref "/docs/concepts/architecture" >}}) to see which packages you need.
- Read [Conventions]({{< relref "/docs/concepts/conventions" >}}) before configuring table prefixes or the user model.
