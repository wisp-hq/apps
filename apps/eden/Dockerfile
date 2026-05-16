# syntax=docker/dockerfile:1

FROM debian:trixie-slim AS nstool-builder
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git ca-certificates && \
  git clone --depth 1 --recursive --branch v1.9.2 https://github.com/jakcron/nstool.git /build && \
  make -C /build -j"$(nproc)" deps && \
  make -C /build -j"$(nproc)" && \
  strip /build/bin/nstool

FROM lscr.io/linuxserver/eden:latest

ARG BUILD_DATE
ARG VERSION
LABEL build_version="wisp-hq version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL org.opencontainers.image.source="https://github.com/wisp-hq/apps"

ENV TITLE=Eden

RUN apt-get update && \
  apt-get install -y --no-install-recommends jq rhash && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

COPY --from=nstool-builder /build/bin/nstool /usr/local/bin/nstool
COPY shared/emulators/wisp-generate-library /usr/local/bin/wisp-generate-library
COPY shared/wisp-reconcile /usr/local/bin/wisp-reconcile
COPY apps/eden/root/ /

RUN chmod +x \
    /usr/local/bin/wisp-generate-library \
    /usr/local/bin/wisp-reconcile \
    /usr/local/bin/nstool \
    /etc/wisp/title-id-extractor \
    /defaults/autostart_wayland
