# Lucida GTM template

`template.tpl` is a Google Tag Manager custom tag template (web containers).

## Install

1. GTM workspace, Templates, Tag Templates, New, menu, Import, choose `template.tpl`, Save.
2. Add a tag of type **Lucida**, tag type **Initialise**, with your public key (`lc_pk_...`).
   Trigger it on All Pages (or after your consent banner fires).
3. Add further **Send event** tags for custom events (name plus property table, values can be
   GTM variables). Properties starting with `$lc_` are dropped.

## Tag types

| Tag type | Queues | Use |
| --- | --- | --- |
| Initialise | `init` | once per page, loads the snippet |
| Send event | `capture` | custom events with a property table |
| Identify | `identify(userId, $set, $set_once)` | on sign-in or sign-up, trigger on the event that carries the user id |
| Alias | `alias(alias[, existingId])` | link a second id (for example a billing id) to the visitor |
| Reset | `reset` | on sign-out, so the next visitor does not inherit the previous user |
| Opt in / Opt out | `optIn` / `optOut` | wire to your consent tool's grant and withdraw events |

All of them are plain client commands, so any `Client` method that takes simple values can be pushed the same way
(`window.lucidaQueue.push(['setConsent', {analytics: true}])`). Property tables drop names starting with `$lc_`.
Do not put an email address into the user id unless you are entitled to.

## Init options

| Field | Maps to |
| --- | --- |
| Project API key | `createClient(key, ...)` (public key only) |
| Ingest host | `apiHost` |
| Snippet URL | script injected with `injectScript` (default `https://cdn.lucida.dev/lucida.js`) |
| Pageviews | `capturePageview`: `'history'`, `true` (initial only), `false` |
| Persistence | `persistence`: `cookie`, `localStorage`, `memory` |
| Autocapture, Respect DNT, Debug | `autocapture`, `consent.respectDnt`, `debug` |

## How it works

GTM sandboxed JS cannot call `import`, so the template pushes commands onto `window.lucidaQueue`
(`['init', key, config]`, `['capture', name, props]`) and injects the snippet. The snippet drains
the queue on load and then handles later pushes directly. Consent: gate the Initialise tag with
GTM consent settings; Lucida itself writes no cookie or storage before consent when
`consent.mode` is opt-in.

## Permissions

`inject_script` is limited to `https://cdn.lucida.dev/*` and `access_globals` to `lucidaQueue`.
Self-hosting the snippet means editing the inject_script permission after import.

## Server container

`server-template.tpl` is a tag template for **server** containers. Import it the same way in the
server container, then add a **Lucida (server)** tag triggered on the events your GA4 client claims.

| GA4 parameter | Lucida |
| --- | --- |
| `event_name` (`page_view`) | event name (`$pageview`), or the override field |
| `user_id`, else `client_id` | `distinct_id` (no id: the tag fails, nothing is sent) |
| `page_location`, `page_referrer`, `page_title`, `screen_resolution`, `language`, `user_agent` | `$current_url`, `$referrer`, `$title`, `$screen`, `$browser_language`, `$raw_user_agent` |
| `ip_override` | `$ip` only with *Send the visitor IP* (kept only when the project captures IPs) |
| other parameters | forwarded as-is with *Forward every event parameter*; `x-*` and `$lc_*` never |

A secret key (`lc_sk_`) posts to `/v1/s2s/batch` (event timestamps kept); a public key posts to `/v1/batch`.
The server container is not visible to browsers, so a secret key is fine there.

## Known gap

The template loads `@lucida/browser`'s classic-script build, `dist/lucida.js` (`src/snippet.ts`):
it drains `window.lucidaQueue` and then runs later pushes immediately. Host it at the snippet URL.

## Check

`cd go && go test ./internal/gtmtemplate` validates every section of the template against
the JSON schemas in `go/internal/gtmtemplate/template_test.go` and cross-checks required APIs against permissions.
Both templates' sandboxed code also runs in goja with the GTM APIs mocked (`web_run_test.go`, `server_test.go`),
so every tag type and the server mapping are executed, not only schema-checked.

---

This repository is a read-only mirror of the Lucida monorepo (synced by a script, never edited by hand); releases and provenance attestations are built here by GitHub Actions. Issues are welcome, changes land upstream.
