# wisp-hq/apps

App catalog for [Wisp](https://github.com/wisp-hq). The Wisp client fetches `manifest.json`, reads each app's `wisp.json`, and renders the catalog dynamically. Users can also point Wisp at any third-party repo that follows the same layout.

## Layout

```
manifest.json          # { schemaVersion, apps: [slug, ...] }
wisp.schema.json       # JSON Schema (draft 2020-12) for wisp.json
<slug>/
  wisp.json            # app manifest
  icon.svg
  Dockerfile           # optional — only when we build our own image
```

## Catalog

| Slug | Image | Built here |
|------|-------|------------|
| firefox | `ghcr.io/wisp-hq/firefox` | yes |
| heroic | `ghcr.io/wisp-hq/heroic` | yes |
| lutris | `ghcr.io/wisp-hq/lutris` | yes |
| pegasus | `ghcr.io/wisp-hq/pegasus` | yes |
| retroarch | `lscr.io/linuxserver/retroarch` | no (upstream) |
| steam | `lscr.io/linuxserver/steam` | no (upstream) |

Images we build are based on linuxserver.io's [`baseimage-selkies`](https://github.com/linuxserver/docker-baseimage-selkies) and expose a web interface on port `3001`.

## Adding an app

1. Create `<slug>/` with a `wisp.json` and `icon.svg` (white-on-transparent SVG, square aspect).
2. Reference the schema at the top of `wisp.json` for editor autocomplete:
   ```json
   { "$schema": "../wisp.schema.json", "slug": "<slug>", ... }
   ```
3. Add a `Dockerfile` in the same folder if the app needs a custom image; otherwise reference an upstream image directly in `wisp.json`.
4. Append the slug to the `apps` array in `manifest.json`.
5. Open a PR — CI validates the schema, checks slug/icon consistency, then builds and publishes any new `Dockerfile` to GHCR.

## Running your own catalog

Wisp lets users register additional catalog repos. To stand one up, mirror the layout above and reference the canonical schema by URL from each `wisp.json`:

```json
{ "$schema": "https://raw.githubusercontent.com/wisp-hq/apps/main/wisp.schema.json" }
```

Reuse the validation workflow as-is:

```yaml
# .github/workflows/validate.yml
name: Validate catalog
on: [push, pull_request]
jobs:
  validate:
    uses: wisp-hq/apps/.github/workflows/validate.yml@main
```

Then point Wisp at your repo's raw `manifest.json` URL and your apps appear alongside the built-in ones.

## CI

- [`build.yml`](.github/workflows/build.yml) builds and publishes each image to GHCR (push to `main`, `v*` tags, weekly rebuild, manual dispatch).
- [`validate.yml`](.github/workflows/validate.yml) validates the catalog on every PR and is also exposed as a reusable workflow.
