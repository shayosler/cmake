#!/bin/bash -x
# build a debian package of gss build packages
version=$(cmake -DVERSION_DIR="./" -P ./get_version.cmake 2>&1)
echo "Making SO CMake package"
checkinstall --nodoc \
--fstrans=yes \
--maintainer='support@greenseainc.com' \
--pkgname=so-build \
--pkglicense= \
--pkggroup=SO \
--pkgversion=$version \
--arch=all \
--provides=so-build \
--backup=no \
-y \
--install=no \
./install_so_build.sh
