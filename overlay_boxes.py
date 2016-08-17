import cv2
import numpy as np
import sys
import argparse
import csv
import os

'''
This script take two inputs: a video and a csv file. The csv file contains the boundaries of different boxes to draw on the frames of each video.
The csv file should have one column and four rows for each box. The first row contains the upper-left x coordinate of the box, the second the upper-left y coordinate, the third the lower-right x coordinate, and the fourth the lower-right y coordinate.

The script outputs one thing: a video identical to the input video but with the boxes overlaid. Saves as whatever the input name was appended with "_overlaid_boxes". For example, "video_a.mp4" will be saved as "video_a_overlaid_boxes.mp4".

Run like: python overlay_boxes.py -i /path/to/video.mp4 -b boxes.csv

written by luke reding 17 august 2016
'''

# functions:
## argument parser
## draw_box

def parse_arguments():
    """Parse arguments."""
    ap = argparse.ArgumentParser()
    ap.add_argument("-i", "--inputVideo", required = True, help = "Path to the video")
    ap.add_argument("-b", "--boxes", required = True, help = "Path to csv containing the box coordinates")
    args = vars(ap.parse_args())
    video_path = args["inputVideo"]
    box_path = args["boxes"]
    return video_path, box_path

def check(video, boxes):
    """Check to make sure the files are as expected."""
    # check to make sure you can read the video
    cap = cv2.VideoCapture(video)
    ret, frame = cap.read()
    if ret == False:
        sys.exit("Problem reading the video.")

    if boxes.endswith('.csv'):
        with open(boxes) as csvfile:
            csvreader = csv.reader(csvfile)
            boxes = []
            for row in csvreader:
                row = int(row[0])
                boxes.append(row)
        if len(boxes) % 4 != 0:
            sys.exit("the csv file containing the boxes needs to have a number of rows that is a multiple of four.")
    else:
        sys.exit("the -b argument should be a csv file")
    return boxes

def draw_boxes(img, boxes):
    """Draw each box on img. len(boxes) == # of boxes to draw."""
    for box in boxes:
        cv2.rectangle(img, (box[0], box[1]), (box[2], box[3]), (25,2,200), 3)
    return img

if __name__ == "__main__":

    # parse the arguments
    video_path, box_path = parse_arguments()

    # error check and get box coordinates
    boxes = check(video_path, box_path)
    boxes = zip(*[boxes[i::4] for i in range(4)])

    # change working directory
    if os.path.dirname(video_path) != '':
        os.chdir(os.path.dirname(video_path))

    # set up video reader
    cap = cv2.VideoCapture(video_path)

    # set up video writer
    video_name = os.path.basename(video_path)
    name = video_name.split('.')[0] + "_overlaid_boxes." + video_name.split('.')[1]
    # get size of video
    width = cap.get(3)
    height = cap.get(4)
    fourcc = cv2.cv.CV_FOURCC('m', 'p', '4', 'v')
    out = cv2.VideoWriter(name, fourcc, cap.get(5), (int(width),int(height)))

    print "starting loop"

    counter = 0
    ret = True
    while ret == True:
        ret, frame = cap.read()
        frame = draw_boxes(frame, boxes)
        out.write(frame)
        counter += 1
        if counter % 100 == 0:
            print "on frame {}".format(counter)

    out.release()
    cap.release()

    print "video with boxes saved @ {}".format(name)
