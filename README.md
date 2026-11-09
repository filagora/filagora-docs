# Filagora docs

Developer documentation for the [Filagora](https://github.com/filagora) packages, built with
[Hugo](https://gohugo.io) and the [Docsy](https://www.docsy.dev) theme.

```bash
npm ci
npm run serve         # hugo server; needs Hugo extended >= 0.160.1, Go and Node 20
```

Concept and contributing pages are hand-written under `content/en/docs/`. The package and
tooling pages are generated from each package's README:

```bash
bash scripts/sync-packages.sh
```

See [This documentation site](content/en/docs/contributing/docs-site.md) for versioning and
publishing. Do not add private hostnames, IP addresses or personal email addresses: CI runs a
leak scan.

## Licence

MIT. See [LICENSE](LICENSE).
