#!/usr/bin/env bash

PATH="$1"

for file in $PATH*.htm
do
    printf "processing $file"
    # get filename without extension
    f=${file%.htm}
    f_=${f##*/}
    printf $f_
    # do the conversion
    /Users/lukereding/Downloads/KindleGen_Mac_i386_v2_9/kindlegen $file -verbose -o $f_.mobi
    # copy onto kindle
    # mv "{$PATH}/{$f_}.mobi" "/Volumes/Kindle/documents/" # not tested
done
