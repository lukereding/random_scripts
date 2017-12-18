# crop all the videos to make them look nicer

ffmpeg -i elizabeth_threshold.avi -filter:v "crop=1000:1000:450:50" -y thresh_cropped.avi
ffmpeg -i elizabeth_tracked.avi -filter:v "crop=1000:1000:450:50" -y tracked_cropped.avi
ffmpeg -i elizabeth_diff_image.avi -filter:v "crop=1000:1000:450:50" -y diff_cropped.avi
ffmpeg -i elizabeth_encoded.mp4 -filter:v "crop=1000:1000:450:50" -y original_cropped.avi

# top video
ffmpeg -i original_cropped.avi -i diff_cropped.avi -vb 2000K -filter_complex "[0:v:0]pad=iw*2:ih[bg]; [bg][1:v:0]overlay=w" -y test.avi

# bottom video
ffmpeg -i thresh_cropped.avi -i tracked_cropped.avi -vb 2000K -filter_complex "[0:v:0]pad=iw*2:ih[bg]; [bg][1:v:0]overlay=w" -y test2.avi

# total
ffmpeg -i test.avi -vf 'pad=iw:2*ih [top]; movie=test2.avi [bottom];
\
[top][bottom] overlay=0:main_h/2' -vb 2000K stacked.avi
