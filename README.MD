### random_scripts

I'm using this repo to keep track of random scripts I write.

## `bkp`

Shell script I use to create compressed archive files for backing up. Used like `bkp /path/to/folder_to_backup destination/`. Uses bzip2.

## `reading_level`

Shell script that uses pandoc, ucto, and readability to calculate readability statistics from a docx or md file. Used like `reading_level some_file.docx`

## `md2pdf`

Shell script that converts markdown files to a pdf using pandoc. Used like `md2pdf some_text.md`. Creates `some_text.pdf` @ `~/Desktop/`. 

## `plotting_functions.R`

A ggplot2 theme I like + some color scales.

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

## `k_means_video.py`
Apply k-means clustering based on color to the frames of a video. Used like `python k_means_video.py -n input_video.mp4 -n 6` where `-n` is the number of groups to use for clustering.

## `unix_tips_and_tricks.md`

A work in progress.

## `mod_time.py`

Get the difference between when a file was created and when it was last modified. Useful when making sure videos are the length you think they are. Used like `python mod_time.py -i /path/to/dir`.

## `overlay_boxes.py`

Written for Kelly to overlap various boxes on a video.

This script take two inputs: a video and a csv file. The csv file contains the boundaries of different boxes to draw on the frames of each video.
The csv file should have one column and four rows for each box. The first row contains the upper-left x coordinate of the box, the second the upper-left y coordinate, the third the lower-right x coordinate, and the fourth the lower-right y coordinate.

The script outputs one thing: a video identical to the input video but with the boxes overlaid. Saves as whatever the input name was appended with _overlaid_boxes. For example, _video_a.mp4_ will be saved as _video_a_overlaid_boxes.mp4_.

Run like: `python overlay_boxes.py -i /path/to/video.mp4 -b boxes.csv`
