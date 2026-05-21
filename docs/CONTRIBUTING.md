# Contributing

## i18n convention

Translatable strings live in per-app `i18n/<locale>.json` files and are referenced from `wisp.json` with the `t:` prefix.

### How it works

- Any string in `wisp.json` may be the literal `"t:<key>"`, which the client resolves from `<slug>/i18n/<defaultLocale>.json`.
- `defaultLocale` on a manifest is optional and defaults to `"en"`. The `<defaultLocale>.json` file is the **source of truth** — every `t:<key>` referenced in a manifest must exist there.
- Other locales (e.g. `fr.json`, `de.json`) are optional translations. The client falls back to the source locale when a key is missing.
- Keys can be nested via dots in the name (e.g. `volumes.config.label`) but the files themselves are flat JSON objects — the dot is part of the key, not a path.

### Layout

```
<slug>/
  wisp.json
  icon.svg
  i18n/
    en.json        # source locale (required if the manifest references any t: key)
    fr.json        # optional translations
```

### Example

`firefox/wisp.json`:

```json
{
  "description": "t:description",
  "volumes": [
    { "id": "profile", "label": "t:volumes.profile.label", ... }
  ]
}
```

`firefox/i18n/en.json`:

```json
{
  "description": "Web browser, sandboxed per user.",
  "volumes.profile.label": "Profile"
}
```

### What CI enforces

The [`lint.yml`](../.github/workflows/lint.yml) workflow runs on every PR and:

- **errors** if a `t:<key>` in a manifest has no entry in its source-locale file;
- **warns** on orphan keys (defined in a locale file but unreferenced);
- **warns** on missing keys in non-source locales (translation gap).

## Bumping `version`

Every change to a `*/wisp.json` must bump that manifest's `version` field (semver). The Wisp client uses it to detect catalog updates. CI fails any PR that mutates a manifest without changing its `version`.

Pure rename/move of an i18n file or icon does not require a version bump — only changes to `wisp.json` content do.
