import cv2
import numpy as np
import sys
import subprocess

# declare some functions:

def draw_rectangle(event, x, y, flags, param):
    global ix, iy, drawing
    drawing = False

    if event == cv2.EVENT_LBUTTONDOWN:
        drawing = True
        ix, iy = x, y
        cv2.circle(frame, (ix,iy), 5, (116,198,122), -1)

    elif event == cv2.EVENT_MOUSEMOVE:
        if drawing == True:
            # print "drawing"
            cv2.rectangle(frame,(ix,iy),(x,y),(98,17,25), 1)

    elif event == cv2.EVENT_LBUTTONUP:
        drawing = False
        cv2.rectangle(frame, (ix, iy), (x, y), (98,17,25), 3)
        global x_end, y_end, x_initial, y_initial
        x_end, y_end, x_initial, y_initial = x, y, ix, iy
        print "x_initial: {}, y_initial: {}, x_end: {}, y_end: {}".format(x_initial, y_initial, x_end, y_end)


def get_first_frame(filename):
    cap = cv2.VideoCapture(filename)
    try:
        ret, frame = cap.read()
        print "dimensions of video: {}".format(frame.shape)
    except:
        sys.exit("problem reading the video file")
    
    cap.release()
    return frame

def make_cropped_video(filename, x, y, width, height, output_name):
    print 'call to ffmpeg:\nffmpeg -i {} -filter:v "crop=w={}:h={}:x={}:y={}" {}'.format(filename, width, height, x, y, output_name)
    
    subprocess.call(
        'ffmpeg -i {} -filter:v "crop=w={}:h={}:x={}:y={}" {}'.format(
            filename, width, height, x, y, output_name),
        shell=True)


def open_cropped_video(filename):
    subprocess.call('open {}'.format(filename), shell=True)


if __name__ == "__main__":

    # get first frame
    video_name = sys.argv[1]
    frame = get_first_frame(video_name)

    # create new window
    cv2.namedWindow('first_frame')
    cv2.setMouseCallback('first_frame', draw_rectangle)
    
    # show it, have the user draw the rectange
    while(1):
        cv2.imshow('first_frame', frame)
        k = cv2.waitKey(1) & 0xFF
        if k == 27:
            break

    cv2.destroyAllWindows()

    w = abs(x_end - x_initial)
    h = abs(y_end - y_initial)
    
    print "width: {}\nheight: {}".format(w, h)
    
    # come up with a new output name
    name = video_name.split('.')[0] + "_cropped." + video_name.split('.')[1]
    
    # have ffmpeg crop the video
    try:
        make_cropped_video(video_name, x_initial, y_initial, w, h, name)
    except:
        sys.exit("problem with subprocess call to ffmpeg")

    # open the new cropped video right away
    open_cropped_video(name)

    # fin
