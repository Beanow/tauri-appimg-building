#!/bin/bash
set -eux

mkdir -p AppDir/usr/bin
mkdir -p AppDir/usr/share/applications
mkdir -p AppDir/usr/share/icons/256x256/apps

cat > AppDir/usr/share/applications/hello-rs.desktop <<EOF
[Desktop Entry]
Categories=Development
Comment=An example Application
Exec=hello-rs
Icon=hello-rs
Name=Hello RS
Terminal=true
Type=Application
EOF

cp -T /output/rusty-hello-rs AppDir/usr/bin/hello-rs
cp -T /icons/256x256.png AppDir/usr/share/icons/256x256/apps/hello-rs.png
