# Filagora docs

Developer documentation for the [Filagora](https://github.com/filagora) packages, built with
[Hugo](https://gohugo.io) and the [Docsy](https://www.docsy.dev) theme.

Needs Hugo **extended** 0.160.1+, Go 1.24+ and Node 20; see
[This documentation site](content/en/docs/contributing/docs-site.md) for installing them and
why `npm run serve` is used instead of `hugo server`.

```bash
npm ci
npm run serve         # runs `hugo server` with Dart Sass on the PATH
```

Concept and contributing pages are hand-written under `content/en/docs/`. The package and
tooling pages are generated from each package's README on every build (not committed on
`master`). To preview them locally:

```bash
bash scripts/sync-packages.sh        # sibling checkouts; SYNC_SOURCE=github fetches releases
```

See [This documentation site](content/en/docs/contributing/docs-site.md) for versioning and
publishing. Do not add private hostnames, IP addresses or personal email addresses: CI runs a
leak scan.

## Licence

MIT. See [LICENSE](LICENSE).
