---
title: JSON API
weight: 50
description: How the plugins package's JSON API is called, who may call it, how it is limited and cached, and how stable it is.
---

The [plugins package]({{< relref "/docs/packages/plugins" >}}) can serve a versioned JSON API: the catalogue, releases, download details, update checks, following a plugin, and the changes owners and staff make. It is **off by default**. Switch it on with `routes.api.enabled` (`FILAGORA_PLUGINS_API_ENABLED`); routes then appear under `routes.api.prefix` (`api/v1`) with names `filagora-plugins.api.*`.

This page is what is true of every call. The routes, parameters and response shapes are in the [OpenAPI description](#the-contract) that ships with the package.

## Who may call

Reads can be made as a guest. For anything else, and for what a read returns, two layers decide.

**A token** needs the ability the endpoint asks for, and its owner needs the matching capability key:

| Ability on the token | Capability key (`routes.api.keys`) | Used for |
| --- | --- | --- |
| `plugins:read` | `api.plugins.read` | The catalogue, releases, update checks, whether you follow a plugin |
| `plugins:download` | `api.plugins.download` | The download link in a response, when downloads are on and you may download |
| `plugins:write` | `api.plugins.write` | Changing a plugin, uploading a release, moderating, following and unfollowing |

A token without the ability is refused with 403, and so is a token whose owner lacks the key. Set a key to `null` in config to ask for none. A browser session needs neither the ability nor the key.

The package never reads a token itself. Bind `Filagora\Plugins\Contracts\ApiUsers` for Passport or anything else; the default asks the guard in `routes.api.guard` (set it to `sanctum`) for the user and the user's `tokenCan()`. The keys are checked through core's [`AccessChecker`]({{< relref "/docs/concepts/access-control" >}}), so with `filagora-entitlements` an `api.plugins.*` grant covers all three.

**What the caller then sees** is decided by plugin type and entitlement, not by the API. The same URL can answer differently to different callers: a members-only type is absent from a guest's list, and a download link is `null` when the caller may not download. The `visibility` parameter widens the view for a signed-in caller who is allowed it (`owner` for their own plugins, `staff` for a moderator's view). For a guest it has no effect.

Endpoints that change something, and the one that reports whether you follow a plugin, need a signed-in caller with a verified email.

## Limits

Each kind of request has its own limit, in requests a minute:

| Limiter | Default | Covers |
| --- | --- | --- |
| `filagora-plugins-api-read` | 120 | Every `GET` |
| `filagora-plugins-api-updates` | 60 | The update check (`POST plugins/updates`) |
| `filagora-plugins-api-write` | 30 | Changing a plugin, uploading, moderating, following, unfollowing |

Set them in `routes.api.throttle` (`FILAGORA_PLUGINS_API_THROTTLE_READ`, `_UPDATES`, `_WRITE`); `0` means no limit. A signed-in caller is counted on their own, whatever the address; a guest is counted by address. Past a limit the answer is **429** with a `Retry-After` header in seconds.

Behind a proxy or a CDN, a guest's address is the one Laravel reports: configure trusted proxies, or every guest shares the proxy's address and one limit. To use your own rules, define a limiter with one of the names above; yours is used.

## Caching

What the API answers depends on who asks, so every response carries `Vary: Authorization`.

- A guest's successful read is **public** for `routes.api.cache_seconds` (60; `0` turns caching off), with an `ETag`. Send the tag back as `If-None-Match` for a 304.
- Anything shown to a signed-in caller, with a token or a session, is **private**, and a refusal or an error is never made public.
- Download links in responses are stable URLs, not signed or expiring ones, so a cached response never holds a dead link.

## Errors and paging

| Status | When | Body |
| --- | --- | --- |
| 401 | No valid credentials | `{"message": "..."}` |
| 403 | Missing ability or capability key, or not permitted to do this | `{"message": "..."}` |
| 404 | No such plugin or release, or one the caller may not see | `{"message": "..."}` |
| 422 | Input refused (a refused upload names the field) | `{"message": "...", "errors": {"field": ["..."]}}` |
| 429 | Past a limit | `{"message": "..."}` and `Retry-After` |
| 503 | Uploads are paused | `{"message": "..."}` |

A plugin or release the caller may not see is a 404, not a 403, so the API does not reveal that it exists (only a request for the `staff` view by someone who is not a moderator is a 403). The update check follows the same rule: plugins that are unknown, hidden or already current are left out of the answer.

The plugin list is paged: `{"data": [...], "links": {...}, "meta": {...}}`, `routes.api.per_page` to a page (15). Every other list is `{"data": [...]}`.

## Adding fields

A host adds properties to plugins and releases through the `ApiFields` contract, and rules for extra upload fields; `PluginIdentifiers` teaches the update check the ids your clients already use. Responses carry **more** properties than the package names, never fewer, so a client should ignore ones it does not know.

## The contract

`resources/openapi/filagora-plugins.yaml` in the package is an OpenAPI 3.1 description of every route, with the abilities, limits, caching headers and error shapes. `Filagora\Plugins\Api\OpenApiSpec::path()` returns its location, so a host can serve it, render it, generate a client from it, or add its own fields to the plugin and release schemas.

A package test fails if a route is added without being described, or described without being served, so the description cannot drift from the code.

Serve it from a path **without a file extension** (`/docs/api/openapi`, not `/docs/api/openapi.yaml`): many web server setups answer static-looking extensions themselves and never pass the request to PHP.

## Stability

The package is `0.x`: the API may change between minor versions, as the [conventions]({{< relref "/docs/concepts/conventions" >}}) say for every package. A patch release does not change a route or a response shape. A minor can add or change them, and when it changes behaviour the changelog says so under **Changed**; read it before moving a minor. New limits are an example: an API that had none starts refusing callers over them, and the changelog says to raise or zero them if a client needs more.

`v1` in the path is the prefix (`routes.api.prefix`), a setting of the host's.

A host that keeps its own older endpoints alongside this API (an unauthenticated check an old client calls, for example) is outside this contract. Document those separately, and do not put the limits or the token layer in front of an endpoint whose callers cannot send a token.
