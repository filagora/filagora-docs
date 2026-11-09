---
title: Extension points
weight: 40
description: The registries, contracts and events you extend instead of editing package code.
---

Extend through documented contracts, events and registries. Anything not documented is `@internal` and may change in any release.

| Extension point | Package | Use it to |
| --- | --- | --- |
| `ModuleRegistry` | core | Register a package and declare what it requires |
| `NavigationGroupRegistry` | core | Declare sidebar groups; hosts override label, icon, sort and collapsed state in config |
| `SettingsRegistry` | core | Add typed settings with defaults to the staff settings screen |
| `ExtensionRegistry` | core | Extend the safe CommonMark/GFM renderer used by `MarkdownRenderer` |
| `Doctor` checks | core | Add health checks to `filagora:doctor` |
| `AccessChecker` | core | Replace how authorization is answered |
| `PrivacyContributor`, `RetentionRule` | core | Export, erase and prune a package's data under the compliance package |
| `SchemaRegistry`, `SchemaExtension` | core | Declare extra columns, indexes and foreign keys for `filagora:adopt` |
| `SearchEngine` contract | search | Add a search engine |

The same pattern applies inside domain packages (for example block types in the CMS, or notification categories). Each package page lists its own registries and events.
