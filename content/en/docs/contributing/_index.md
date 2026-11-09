---
title: Contributing
weight: 50
description: Working on the packages and on this documentation site.
---

## Working on a package

Each package's `CONTRIBUTING.md` is authoritative. The shared expectations:

```bash
composer install
composer test      # Pest, against a real MariaDB database named `testing`
composer lint      # Pint
composer analyse   # Larastan
```

- `master` is protected: open a pull request; it is squash-merged once CI is green.
- Behaviour changes ship with tests; bug fixes ship with a regression test that fails before the fix.
- Do not add private hostnames, IP addresses or personal email addresses to code, docs or fixtures. CI runs a leak scan. The same applies to this site.

CI for every package is the same three jobs (`tests`, `lint`, `leak-scan`) provided by [Shared workflows]({{< relref "/docs/tooling/shared" >}}). Tagging `v*` creates a GitHub release from the matching `CHANGELOG.md` section.
