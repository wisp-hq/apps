# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:ubunturesolute

ARG BUILD_DATE
ARG VERSION
ARG HEROIC_VERSION=2.22.0
LABEL build_version="wisp-hq version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL org.opencontainers.image.source="https://github.com/wisp-hq/apps"

ENV TITLE=Heroic

RUN \
  echo "**** install runtime deps ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    libasound2t64 \
    libgbm1 \
    libgtk-3-0 \
    libnotify4 \
    libnss3 \
    libsecret-1-0 \
    libxss1 \
    libxtst6 \
    xdg-utils && \
  echo "**** install heroic ${HEROIC_VERSION} ****" && \
  curl -fSLo /tmp/heroic.deb \
    "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v${HEROIC_VERSION}/Heroic-${HEROIC_VERSION}-linux-amd64.deb" && \
  apt-get install -y --no-install-recommends /tmp/heroic.deb && \
  rm /tmp/heroic.deb && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

COPY root/ /

EXPOSE 3001
VOLUME /config
