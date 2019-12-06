#!/bin/bash -ex
# Get the cmake version
dir=$1
if [[ -z "$dir" ]]
then
    dir=./
fi

if [[ ! -d $dir ]]
then
    dir=$(dirname $dir)
fi

# Location of cmake files
cmake_dir=/usr/local/share/cmake/so_cmake
cmake -DVERSION_DIR="$dir" -P $cmake_dir/get_version.cmake 2>&1
