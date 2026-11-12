---
title: Access control
weight: 30
description: How packages ask whether a user may do something, and how to plug in your own answer.
---

Every package asks one question: *may this user do this?* It asks it through core's `AccessChecker`, using a key from the package's `gates` config, and never implements its own permission logic.

## Who answers

- With [`filagora-entitlements`]({{< relref "/docs/packages/entitlements" >}}) installed, `AuthorizationService` is bound as the `AccessChecker`. Answers come from entitlement grants: default grants, direct grants (with start, expiry and revocation) and grants other packages contribute. Wildcards work, so `api.plugins.*` covers `api.plugins.read`.
- Without it, bind your own `Filagora\Core\Contracts\AccessChecker` in a service provider (roles, policies, a permissions package). Every package follows it.
- With nothing bound, everyone is denied and `filagora:doctor` says so.

## Frontend moderation without dashboard access

Some staff should moderate on your own pages without seeing the dashboard's screens for it, for example an editor who also keeps the forums tidy. Core defines one shared ability for this, `filagora.moderate_frontend` (`Filagora\Core\Support\Abilities::MODERATE_FRONTEND`), mapped to a key in the `gates` of core's config like any other. Define it in core, not in a package, because more than one package honours it: [forums]({{< relref "/docs/packages/forums" >}}) accepts it today, and any package with moderation can follow without depending on `filagora-entitlements`.

The rule every package follows:

- **Frontend checks accept either ability.** In forums, `ForumAccess::canModerate()` allows `filagora.forums.moderate` or `filagora.moderate_frontend`, so the moderation services, and any host policy built on that method, work for both. A holder of the shared ability also counts as staff.
- **Dashboard screens keep their own ability.** Forum screens still need `filagora.forums.moderate`. A user who holds only the shared ability opens no forum screen, and with nothing else granted sees an empty dashboard.
- **Gate a dashboard screen with the ability, not with a policy.** Use `GatedByAbility` (forums wraps it as `GatedByModerate`). A screen gated only through a model policy opens to whoever the policy later admits: `filagora-forum-bugreports` asked `BugReportPolicy`, which asks `canModerate()`, so widening `canModerate()` opened its screen to frontend-only moderators until the screen was gated on the full ability.

A host that remaps core's `gates` to its own keys remaps this ability the same way (the Zen Cart profile maps it to `operator.forum.moderate_frontend`). With `filagora-entitlements`, `filagora:entitlements:sync` creates a definition for the key, so it can be granted from the dashboard like any entitlement.

Two things to check in a host's own panel: Filament lets a resource through when its model has no policy at all, and a plugin that is gated only for navigation stays reachable by URL. Neither is true of the Filagora packages' screens, which deny by default.

## In your own code

Define a package's Gate abilities from its `gates` config with `GateAbilities`, and gate every action of a Filament resource behind one ability with the `GatedByAbility` trait. Policies in a host can use entitlements' `AuthorizesWithEntitlements` trait. Do not re-implement these checks: keep entitlement resolution centralised so behaviour stays explicit and auditable.

`EntitlementResolver::explain()` reports where an entitlement came from, which is the first thing to call when a user can or cannot do something unexpectedly.
