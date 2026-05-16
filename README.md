# wisp-hq/apps

App catalog for [Wisp](https://github.com/wisp-hq). The Wisp client fetches `manifest.json`, reads each app's `app.json`, and renders the catalog dynamically. Users can also point Wisp at any third-party repo that follows the same layout.

## Layout

```
manifest.json          # catalog metadata + app list
manifest.schema.json   # JSON Schema (draft 2020-12) for manifest.json
apps/
  app.schema.json      # JSON Schema (draft 2020-12) for app.json
  <slug>/
    app.json           # app manifest
    icon.svg
    i18n/<locale>.json # optional — translated strings (see docs/CONTRIBUTING.md)
    Dockerfile         # optional — only when we build our own image
    root/              # optional — files overlaid onto the image at build
shared/                # shared assets across multiple apps
  emulators/
    wisp-generate-library   # ROM library scanner used by all emulator images
```

## Catalog

| Slug | Category | Image | Built here |
|------|----------|-------|------------|
| azahar | emulator | `ghcr.io/wisp-hq/azahar` | yes (extends LSIO) |
| cemu | emulator | `ghcr.io/wisp-hq/cemu` | yes (custom) |
| eden | emulator | `ghcr.io/wisp-hq/eden` | yes (extends LSIO) |
| firefox | browser | `lscr.io/linuxserver/firefox` | no (upstream) |
| heroic | launcher | `ghcr.io/wisp-hq/heroic` | yes |
| lutris | launcher | `ghcr.io/wisp-hq/lutris` | yes |
| retroarch | emulator | `ghcr.io/wisp-hq/retroarch` | yes (extends LSIO) |
| rpcs3 | emulator | `ghcr.io/wisp-hq/rpcs3` | yes (extends LSIO) |
| steam | launcher | `lscr.io/linuxserver/steam` | no (upstream) |
| xemu | emulator | `ghcr.io/wisp-hq/xemu` | yes (extends LSIO) |

Images we build are based on linuxserver.io's [`baseimage-selkies`](https://github.com/linuxserver/docker-baseimage-selkies) and expose a web interface on port `3001`. Emulator images all share [`shared/emulators/wisp-generate-library`](shared/emulators/wisp-generate-library), which scans `/roms` and emits a `library.json` consumed by wisp's `library-file` shortcuts provider.

## Adding an app

1. Create `apps/<slug>/` with an `app.json` and `icon.svg` (white-on-transparent SVG, square aspect).
2. Reference the schema at the top of `app.json` for editor autocomplete:
   ```json
   { "$schema": "../app.schema.json", "slug": "<slug>", ... }
   ```
3. Add a `Dockerfile` in the same folder if the app needs a custom image; otherwise reference an upstream image directly in `app.json`.
4. Append the folder path (e.g. `apps/<slug>`) to the `apps` array in `manifest.json`.
5. If the manifest uses any `t:<key>` strings, add `i18n/en.json` (and optionally other locales). See [`docs/CONTRIBUTING.md`](docs/CONTRIBUTING.md) for the i18n convention.
6. Bump `version` on every change — CI rejects PRs that modify an `app.json` without bumping it.
7. Open a PR — CI validates the schema, checks slug/icon/i18n consistency, then builds and publishes any new `Dockerfile` to GHCR.

## Running your own catalog

Wisp lets users register additional catalog repos. Reference the canonical schemas by URL — `manifest.json` describes your catalog (name, description, homepage, the apps it ships) and each `app.json` describes one app. The `apps` array in `manifest.json` lists **folder paths relative to the manifest** (the last segment must match the `slug` declared inside that folder's `app.json`). You can lay out apps however you like (flat at the root, grouped under `apps/`, by category, …):

```json
// manifest.json — flat layout
{
  "$schema": "https://raw.githubusercontent.com/wisp-hq/apps/main/manifest.schema.json",
  "schemaVersion": 1,
  "name": "Indie Apps",
  "description": "Apps I curate for my friends.",
  "homepage": "https://github.com/me/indie-apps",
  "apps": ["my-app"]
}

// my-app/app.json
{ "$schema": "https://raw.githubusercontent.com/wisp-hq/apps/main/apps/app.schema.json", "slug": "my-app", ... }
```

```json
// manifest.json — grouped layout
{
  "schemaVersion": 1,
  "name": "Themed Catalog",
  "apps": ["browsers/firefox", "gaming/steam", "gaming/heroic"]
}
```

Reuse the lint workflow as-is:

```yaml
# .github/workflows/lint.yml
name: Lint catalog
on: [push, pull_request]
jobs:
  lint:
    uses: wisp-hq/apps/.github/workflows/lint.yml@main
```

Then point Wisp at your repo's raw `manifest.json` URL and your apps appear alongside the built-in ones.

## CI

- [`build.yml`](.github/workflows/build.yml) builds and publishes each image to GHCR (push to `main`, `v*` tags, weekly rebuild, manual dispatch).
- [`lint.yml`](.github/workflows/lint.yml) validates the catalog (schema, slug/icon, i18n, version bump) on every PR and push, and is also exposed as a reusable workflow.
