#!/bin/bash
cmake_dir=/usr/local/share/cmake/so_cmake
bin_dir=/usr/local/bin/

[ -d /usr/local/share/cmake ] || mkdir /usr/local/share/cmake/
[ -d $cmake_dir ] || mkdir $cmake_dir
cp *.cmake $cmake_dir
cp *.h.in $cmake_dir
cp -rf doc $cmake_dir
cp -rf cmake-modules $cmake_dir
cp get_version.sh $bin_dir
