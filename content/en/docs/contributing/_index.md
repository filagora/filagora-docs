---
title: Contributing
weight: 50
description: Working on the packages and on this documentation site.
---

**Start with [Local development]({{< relref "local-development" >}})**: checking a package out, running its tests, and developing it inside the demo app.

## Expectations

Each package's `CONTRIBUTING.md` is authoritative. The shared expectations:

- `master` is protected: open a pull request; it is squash-merged once CI is green.
- Behaviour changes ship with tests; bug fixes ship with a regression test that fails before the fix.
- Do not add private hostnames, IP addresses or personal email addresses to code, docs or fixtures. CI runs a leak scan. The same applies to this site.

CI for every package is the same three jobs (`tests`, `lint`, `leak-scan`) provided by [Shared workflows]({{< relref "/docs/tooling/shared" >}}). Tagging `v*` creates a GitHub release from the matching `CHANGELOG.md` section.

## Licensing and the CLA

Every Filagora repository is MIT licensed. There is no separate form to sign and no CLA bot to
wait for: **by submitting a pull request you agree that your contribution is licensed under the
repository's MIT License.** That is the whole agreement, and it is the same one for every package.

The [Filagora Contributor License Agreement](https://github.com/filagora/filagora-zencart-site/blob/HEAD/public/cla.txt)
spells the same terms out in full:

- You license your contribution under the MIT License and no other. Contributions are not
  accepted under proprietary, copyleft or other terms, and you keep ownership of your own work.
- You confirm you are entitled to license it: it is your own work, any third-party material is
  identified and MIT-compatible, and if an employer has rights in it you have their permission.
- The maintainers decide what is merged; submitting a contribution does not guarantee inclusion.
- The contribution is provided "as is", without warranty.

Each repository's `CONTRIBUTING.md` carries a one-line version of this, and its `LICENSE` file is
the licence text. If you cannot agree to these terms, please do not open a pull request.
