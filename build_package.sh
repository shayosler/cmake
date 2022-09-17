#!/bin/bash
# Build a .deb package.
# Files to be included in the package should be in a directory
# with the same name as the package to build

# Build parameters:
pkgname=so-build
description="SNO cmake files"
version=$(cmake -DVERSION_DIR="./" -P ./get_version.cmake 2>&1)
arch=all
pkgversion=1
depends=""
conflicts=
replaces=
breaks=
run_ldconfig=false

# Clean previous build
mkdir -p build
rm -rf build/*

# Build package
deb_name="${pkgname}_${version}-${pkgversion}_${arch}"
deb_dir="build/$deb_name"
mkdir -p "${deb_dir}/usr/local/bin/" || exit 1
mkdir -p "${deb_dir}/usr/local/share/cmake/" || exit 1
mkdir -p "${deb_dir}/usr/local/share/gss/" || exit 1
mkdir -p "${deb_dir}/usr/local/src/" || exit 1
current=$(pwd)
./install_so_build.sh "$(pwd)/${deb_dir}"
cd "$current" || { echo "Failed to return to base directory"; exit 1; }
mkdir "$deb_dir/DEBIAN/"
cat << EOF > "$deb_dir/DEBIAN/control"
Package: $pkgname
Version: $version-$pkgversion
Section: SO
Priority: optional
Architecture: $arch
Depends: $depends
Breaks: $breaks
Replaces: $replaces
Conflicts: $conflicts
Maintainer: Greensea Systems <support@greensea.com>
Description: $description
EOF

# Trigger ldconfig if necessary
if [[ "$run_ldconfig" == "true" ]]
then
  cat << EOF > "$deb_dir/DEBIAN/triggers"
activate-noawait ldconfig
EOF
fi

fakeroot dpkg-deb --build "$deb_dir"

cp "build/${deb_name}.deb" ./
