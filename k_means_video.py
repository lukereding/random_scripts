import cv2
import numpy as np
from skimage import io, segmentation as seg, color
import sys
import argparse

def mean_color(image, labels):
    out = np.zeros_like(image)
    for label in np.unique(labels):
        indices = np.nonzero(labels == label)
        out[indices] = np.mean(image[indices], axis=0)
    return out


ap = argparse.ArgumentParser()
ap.add_argument("-i", "--input", required = True, help = "Path to the video")
ap.add_argument("-n", "--number_segments", required = False, help = "number of segments", default = 100)
args = vars(ap.parse_args())


cap = cv2.VideoCapture(args["input"])
ret, frame = cap.read()
if ret == False:
    sys.exit("couldn't read video file")

frame = cv2.resize(frame, (int(frame.shape[0]),int(frame.shape[1])))
width, height, _ = frame.shape
print "width: {}\nheight: {}".format(width, height)
# set up video writer
fourcc = cv2.cv.CV_FOURCC('m', 'p', '4', 'v')
out = cv2.VideoWriter('out.avi',fourcc, 20.0, (int(width),int(height)))
counter = 0
print "looks good"

while True:
    ret, image = cap.read()
    if ret == False:
        cap.release()
        out.release()

        print "wrote output video to output.avi"
        sys.exit(0)
        
    # resize to make things run faster
    image = cv2.resize(image, (width, height))
    # segment
    labels = seg.slic(image, n_segments=int(args["number_segments"]))
    final = mean_color(image, labels)
    cv2.imwrite("final.jpg", final)
    out.write(final)
    counter += 1
    if counter % 100 == 0:
        print "on frame {}".format(counter)

    
    


