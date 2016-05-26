### random_scripts

I'm using this repo to keep track of random scripts I write.

## `convert_htm_to_mobi.sh`    
I've been disappointed with the ability to download free, old books from [project gutenberg](https://www.gutenberg.org/) and use them on my Kindle. When I download the books as .mobi files, I can't change the font style. When I download them as plain text documents, there's weird line spacing.     

This script uses amazon's [KindleGen](https://www.amazon.com/gp/feature.html?docId=1000765211) command line tool to convert .htm books from the project gutenberg site to .mobi files that the Kindle can read. There are no funky spacing issues and you can choose whatever font you'd like.

The script is run like `bash -x convert_htm_to_mobi.sh /path/to/dir/with/htm/files/`. It'll save the results .mobi files the directory containing the /htm files. The filenames of the htm files can't have spaces.

## `crop_video.py`

Opens the first frame of a video. The user draws a rectangle. The video is cropped to fit the rectangle with a subprocess call to ffmpeg. Run like `python crop_video.py /path/to/video`

## `encode`
Script I use for encoding videos. I put it in `/usr/local/bin/` so that it can be executed no matter where you are in the machine. Makes an `encoded` folder wherever the raw video is and saves the encoded video with the same name to that folder. It does not delete the old video.

_useage:_ `encode /path/to/video`

## `video_to_gif.sh`
Use to convert a video to a gif, which is more portable and is a fail-safe when embedding in powerpoint / keynote presentations. Requires that ffmpeg be installed on your machine. Use it like

`video_to_gif /path/to/video`.