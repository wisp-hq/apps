# syntax=docker/dockerfile:1

FROM lscr.io/linuxserver/azahar:latest

ARG BUILD_DATE
ARG VERSION
LABEL build_version="wisp-hq version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL org.opencontainers.image.source="https://github.com/wisp-hq/apps"

ENV TITLE=Azahar \
    PIXELFLUX_WAYLAND=true

RUN pacman -Sy --noconfirm jq rhash && \
  pacman -Scc --noconfirm && \
  rm -rf /var/tmp/* /tmp/*

COPY shared/emulators/wisp-generate-library /usr/local/bin/wisp-generate-library
COPY shared/wisp-reconcile /usr/local/bin/wisp-reconcile
COPY apps/azahar/root/ /

RUN cp /defaults/autostart /defaults/autostart_wayland && \
  chmod +x /usr/local/bin/wisp-generate-library /usr/local/bin/wisp-reconcile /defaults/autostart /defaults/autostart_wayland
