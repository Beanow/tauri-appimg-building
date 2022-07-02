FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -yq install \
  binutils coreutils desktop-file-utils fakeroot fuse \
  libgdk-pixbuf2.0-dev patchelf python3-pip python3-setuptools \
  squashfs-tools strace util-linux zsync wget gtk-update-icon-cache

RUN wget https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage -O /opt/appimagetool \
    && chmod +x /opt/appimagetool \
    && cd /opt/; sed -i 's|AI\x02|\x00\x00\x00|' appimagetool; /opt/appimagetool --appimage-extract \
    && mv /opt/squashfs-root /opt/appimagetool.AppDir \
    && ln -s /opt/appimagetool.AppDir/AppRun /usr/local/bin/appimagetool

WORKDIR /tmp
RUN wget https://github.com/NixOS/patchelf/releases/download/0.12/patchelf-0.12.tar.bz2; \
    tar -xvf patchelf-0.12.tar.bz2;  \
    cd patchelf-0.12.20200827.8d3a16e; \
    ./configure && make && make install; \
    rm -rf patchelf-*

WORKDIR /
RUN pip3 install appimage-builder

RUN set -eux; \
    useradd --uid 1000 --create-home builder; \
    mkdir /src; \
    chown builder:builder /src;

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    libwebkit2gtk-4.0-37 xdg-utils x11-utils;

USER builder
WORKDIR /src
CMD bash
