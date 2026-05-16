# syntax=docker/dockerfile:1

FROM lscr.io/linuxserver/retroarch:latest

ARG BUILD_DATE
ARG VERSION
LABEL build_version="wisp-hq version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL org.opencontainers.image.source="https://github.com/wisp-hq/apps"

ENV TITLE=RetroArch \
    PIXELFLUX_WAYLAND=true

RUN apt-get update && \
  apt-get install -y --no-install-recommends jq rhash && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

COPY shared/emulators/wisp-generate-library /usr/local/bin/wisp-generate-library
COPY apps/retroarch/root/ /

RUN cp /defaults/autostart /defaults/autostart_wayland && \
  chmod +x /usr/local/bin/wisp-generate-library /defaults/autostart /defaults/autostart_wayland
