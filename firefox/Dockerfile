# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:ubunturesolute

ARG BUILD_DATE
ARG VERSION
LABEL build_version="wisp-hq version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL org.opencontainers.image.source="https://github.com/wisp-hq/apps"

ENV TITLE=Firefox \
    PIXELFLUX_WAYLAND=true

RUN \
  echo "**** install firefox ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends software-properties-common && \
  add-apt-repository -y ppa:xtradeb/apps && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    firefox \
    ^firefox-locale && \
  echo "**** default firefox settings ****" && \
  FIREFOX_SETTING="/usr/lib/firefox/browser/defaults/preferences/firefox.js" && \
  echo 'pref("datareporting.policy.firstRunURL", "");' > ${FIREFOX_SETTING} && \
  echo 'pref("datareporting.policy.dataSubmissionEnabled", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("datareporting.healthreport.service.enabled", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("datareporting.healthreport.uploadEnabled", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("trailhead.firstrun.branches", "nofirstrun-empty");' >> ${FIREFOX_SETTING} && \
  echo 'pref("browser.aboutwelcome.enabled", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("security.sandbox.warn_unprivileged_namespaces", false);' >> ${FIREFOX_SETTING} && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /config/.cache \
    /config/.launchpadlib \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

COPY root/ /

EXPOSE 3001
VOLUME /config
