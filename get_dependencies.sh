#!/bin/bash
binary=$1

libs=($(ldd "$binary" | awk '{print $3}'))
deps=
for lib in "${libs[@]}"
do
    pkgs=($(dpkg -S "$lib" 2> /dev/null | awk -F: '{print $1}')) 
    if [[ -n "$pkgs" ]]
    then
        for pkg in "${pkgs[@]}"
        do
            version=$(dpkg -s "$pkg" | grep '^Version:' | awk '{print $2}')
            dep="$pkg (= $version)"
            if [[ -z "$deps" ]]
            then
                deps="$dep"
            else
                deps="${deps}, $dep"
            fi
        done
    else
        echo "$lib not from a package"
    fi
done
echo "Dependencies: $deps"
