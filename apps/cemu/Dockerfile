# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

ARG BUILD_DATE
ARG VERSION
ARG CEMU_VERSION
LABEL build_version="wisp-hq version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL org.opencontainers.image.source="https://github.com/wisp-hq/apps"

ENV TITLE=Cemu \
    PIXELFLUX_WAYLAND=true

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    rhash && \
  echo "**** install Cemu (Wii U) ****" && \
  CEMU_VERSION="${CEMU_VERSION:-$(curl -fsSL https://api.github.com/repos/cemu-project/Cemu/releases/latest | jq -r '.tag_name')}" && \
  CEMU_VERSION_BARE="${CEMU_VERSION#v}" && \
  echo "Cemu version: ${CEMU_VERSION}" && \
  curl -fSLo /tmp/cemu.AppImage \
    "https://github.com/cemu-project/Cemu/releases/download/${CEMU_VERSION}/Cemu-${CEMU_VERSION_BARE}-x86_64.AppImage" && \
  chmod +x /tmp/cemu.AppImage && \
  (cd /opt && /tmp/cemu.AppImage --appimage-extract > /dev/null && mv squashfs-root cemu) && \
  rm /tmp/cemu.AppImage && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

COPY shared/emulators/wisp-generate-library /usr/local/bin/wisp-generate-library
COPY apps/cemu/root/ /

RUN cp /defaults/autostart /defaults/autostart_wayland && \
  chmod +x \
    /usr/local/bin/wisp-generate-library \
    /etc/wisp/title-id-extractor \
    /defaults/autostart \
    /defaults/autostart_wayland
