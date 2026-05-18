# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:ubunturesolute

ARG BUILD_DATE
ARG VERSION
ARG PEGASUS_DEB_URL
ARG EDEN_VERSION
ARG AZAHAR_VERSION
ARG CEMU_VERSION
LABEL build_version="wisp-hq version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL org.opencontainers.image.source="https://github.com/wisp-hq/apps"

ENV TITLE=Pegasus

RUN \
  echo "**** install runtime deps ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gstreamer1.0-libav \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    jq \
    libqt5gui5 \
    libqt5multimedia5 \
    libqt5qml5 \
    libqt5quick5 \
    libqt5quickcontrols2-5 \
    libqt5svg5 \
    libsdl2-2.0-0 \
    qml-module-qtmultimedia \
    qml-module-qtquick-controls2 \
    qml-module-qtquick2 && \
  echo "**** install pegasus ****" && \
  PEGASUS_DEB_URL="${PEGASUS_DEB_URL:-$(curl -fsSL https://api.github.com/repos/mmatyas/pegasus-frontend/releases/tags/continuous | jq -r '[.assets[] | select(.name | test("_amd64\\.deb$"))][0].browser_download_url')}" && \
  echo "Pegasus deb: ${PEGASUS_DEB_URL}" && \
  curl -fSLo /tmp/pegasus.deb "${PEGASUS_DEB_URL}" && \
  apt-get install -y --no-install-recommends /tmp/pegasus.deb && \
  rm /tmp/pegasus.deb && \
  echo "**** install retroarch + cores ****" && \
  apt-get install -y --no-install-recommends \
    libretro-fceumm \
    libretro-genesisplusgx \
    libretro-mgba \
    libretro-mupen64plus-next \
    libretro-pcsx-rearmed \
    libretro-snes9x \
    retroarch && \
  echo "**** install Eden (Switch) ****" && \
  EDEN_VERSION="${EDEN_VERSION:-$(curl -fsSL https://git.eden-emu.dev/api/v1/repos/eden-emu/eden/releases/latest | jq -r '.tag_name')}" && \
  echo "Eden version: ${EDEN_VERSION}" && \
  curl -fSLo /tmp/eden.AppImage \
    "https://git.eden-emu.dev/eden-emu/eden/releases/download/${EDEN_VERSION}/Eden-Linux-${EDEN_VERSION}-amd64-gcc-standard.AppImage" && \
  chmod +x /tmp/eden.AppImage && \
  (cd /opt && /tmp/eden.AppImage --appimage-extract > /dev/null && mv squashfs-root eden) && \
  rm /tmp/eden.AppImage && \
  echo "**** install Azahar (3DS) ****" && \
  AZAHAR_VERSION="${AZAHAR_VERSION:-$(curl -fsSL https://api.github.com/repos/azahar-emu/azahar/releases/latest | jq -r '.tag_name')}" && \
  echo "Azahar version: ${AZAHAR_VERSION}" && \
  curl -fSLo /tmp/azahar.AppImage \
    "https://github.com/azahar-emu/azahar/releases/download/${AZAHAR_VERSION}/azahar.AppImage" && \
  chmod +x /tmp/azahar.AppImage && \
  (cd /opt && /tmp/azahar.AppImage --appimage-extract > /dev/null && mv squashfs-root azahar) && \
  rm /tmp/azahar.AppImage && \
  echo "**** install Cemu (Wii U) ****" && \
  CEMU_VERSION="${CEMU_VERSION:-$(curl -fsSL https://api.github.com/repos/cemu-project/Cemu/releases/latest | jq -r '.tag_name')}" && \
  CEMU_VERSION_BARE="${CEMU_VERSION#v}" && \
  echo "Cemu version: ${CEMU_VERSION}" && \
  curl -fSLo /tmp/cemu.AppImage \
    "https://github.com/cemu-project/Cemu/releases/download/${CEMU_VERSION}/Cemu-${CEMU_VERSION_BARE}-x86_64.AppImage" && \
  chmod +x /tmp/cemu.AppImage && \
  (cd /opt && /tmp/cemu.AppImage --appimage-extract > /dev/null && mv squashfs-root cemu) && \
  rm /tmp/cemu.AppImage && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

COPY root/ /

RUN chmod +x \
  /usr/local/bin/discover-games \
  /usr/local/bin/rom-launcher

EXPOSE 3001
VOLUME /config
