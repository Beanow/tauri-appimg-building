#!/bin/bash
set -eux

readonly name=${1:-"hello-rs"}

mkdir -p AppDir/usr/bin
mkdir -p AppDir/usr/share/applications
mkdir -p AppDir/usr/share/icons/256x256/apps

cat > AppDir/usr/share/applications/${name}.desktop <<EOF
[Desktop Entry]
Categories=Development
Comment=An example Application
Exec=${name}
Icon=${name}
Name=Hello RS
Terminal=true
Type=Application
EOF

cp -T /output/rusty-${name} AppDir/usr/bin/${name}
cp -T /icons/256x256.png AppDir/usr/share/icons/256x256/apps/${name}.png
