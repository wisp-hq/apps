# wisp-hq/apps

Application containers used by the wisp stack. Each image is built on top of linuxserver.io's [`baseimage-selkies`](https://github.com/linuxserver/docker-baseimage-selkies) and exposes a web interface on port `3001`.

## Available images

| App | Image | Description |
|-----|-------|-------------|
| Firefox | `ghcr.io/wisp-hq/firefox` | Web browser |
| Heroic | `ghcr.io/wisp-hq/heroic` | Epic / GOG / Amazon Games launcher |
| Lutris | `ghcr.io/wisp-hq/lutris` | Linux game launcher with Wine stack |
| Pegasus | `ghcr.io/wisp-hq/pegasus` | Emulation frontend |

## Usage

```bash
docker run -d \
  --name=firefox \
  -p 3001:3001 \
  -v /path/to/config:/config \
  ghcr.io/wisp-hq/firefox:latest
```

Then open `http://localhost:3001`.

## Local build

```bash
docker build -t wisp-<app> ./<app>
```

## CI

The [`.github/workflows/build.yml`](.github/workflows/build.yml) workflow builds and publishes each image to GHCR:

- on every push to `main` (tagged `latest`)
- on every `v*` tag
- every Monday at 04:00 UTC (rebuild against the latest linuxserver base)
- manually via `workflow_dispatch`
