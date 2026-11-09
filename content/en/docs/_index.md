---
title: Documentation
linkTitle: Docs
weight: 20
menu:
  main:
    weight: 20
---

Developer documentation for the Filagora packages. It explains how the code is organised, how to install and configure each package, and how to extend them safely.

- **[Getting started]({{< relref "getting-started" >}})**: install the packages and run the demo app.
- **[Concepts]({{< relref "concepts" >}})**: architecture, conventions, access control and extension points that apply to every package.
- **[Packages]({{< relref "packages" >}})**: per-package reference.
- **[Tooling]({{< relref "tooling" >}})**: the demo app, package skeleton and shared CI workflows.
- **[Contributing]({{< relref "contributing" >}})**: working on the packages and on this site.

{{% alert title="0.x" color="warning" %}}
The packages are pre-1.0. The documented contracts, config keys, events and registries follow SemVer; in `0.x` a minor version may still change them. Anything not documented is `@internal`.
{{% /alert %}}
