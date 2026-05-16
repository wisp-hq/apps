# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:ubunturesolute

ARG BUILD_DATE
ARG VERSION
LABEL build_version="wisp-hq version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL org.opencontainers.image.source="https://github.com/wisp-hq/apps"

ENV TITLE=Lutris

RUN \
  echo "**** enable i386 + multiverse ****" && \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y --no-install-recommends software-properties-common && \
  add-apt-repository -y universe && \
  add-apt-repository -y multiverse && \
  apt-get update && \
  echo "**** install lutris + wine stack ****" && \
  apt-get install -y --no-install-recommends \
    cabextract \
    fonts-wine \
    libwine \
    libwine:i386 \
    lutris \
    p7zip-full \
    wine \
    wine32 \
    wine64 \
    winetricks && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

COPY apps/lutris/root/ /

EXPOSE 3001
VOLUME /config
