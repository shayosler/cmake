#!/bin/bash
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
cmake_dir=/home/shay/development/cmake
cmake -DVERSION_DIR="$dir" -P $cmake_dir/get_version.cmake 2>&1
