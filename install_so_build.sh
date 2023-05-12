#!/bin/bash
root="$1"
cmake_dir="$root"/usr/local/share/cmake/so_cmake
bin_dir="$root"/usr/local/bin/

[ -d /usr/local/share/cmake ] || mkdir /usr/local/share/cmake/
[ -d "$cmake_dir" ] || mkdir "$cmake_dir"
cp *.cmake "$cmake_dir"
cp *.in "$cmake_dir"
cp -rf doc "$cmake_dir"
cp -rf cmake-modules "$cmake_dir"
cp get_version.sh "$bin_dir"
cp gpl-3.0.txt "$cmake_dir"
