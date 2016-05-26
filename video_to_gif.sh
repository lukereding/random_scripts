#!/usr/bin/env bash

# to convert a video into a gif using ffmpeg

if [ -z "$1" ]
  then
    echo "supply a video to create a gif."
    exit 1
fi

which ffmpeg
if [ $? -gt 0 ]; then
    echo "install ffmpeg on your system."
fi

ffmpeg -i $1 -vf fps=30,scale=1280:-1:flags=lanczos,palettegen palette.png

ffmpeg -i $1 -i palette.png -filter_complex "fps=30,scale=1280:-1:flags=lanczos[x];[x][1:v]paletteuse" -y output.gif

rm palette.png

open .