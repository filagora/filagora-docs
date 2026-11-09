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

## In your own code

Define a package's Gate abilities from its `gates` config with `GateAbilities`, and gate every action of a Filament resource behind one ability with the `GatedByAbility` trait. Policies in a host can use entitlements' `AuthorizesWithEntitlements` trait. Do not re-implement these checks: keep entitlement resolution centralised so behaviour stays explicit and auditable.

`EntitlementResolver::explain()` reports where an entitlement came from, which is the first thing to call when a user can or cannot do something unexpectedly.
