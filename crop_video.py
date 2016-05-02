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

    elif event == cv2.EVENT_MOUSEMOVE:
        if drawing == True:
            print "drawing"
            # cv2.rectangle(frame,(ix,iy),(x,y),(0,255,0), 3)

    elif event == cv2.EVENT_LBUTTONUP:
        drawing = False
        cv2.rectangle(frame, (ix, iy), (x, y), (0, 255, 0), 3)
        print "ix: {}, iy: {}, x: {}, y: {}".format(ix, iy, x, y)
        global x_end, y_end
        x_end, y_end = x, y


def get_first_frame(filename):
    cap = cv2.VideoCapture(filename)
    try:
        ret, frame = cap.read()
        # print instructions on the frame
        # cv2.putText(frame, "draw rectangle and press q when done", (50,50))
        cap.release()
        return frame
    except:
        sys.exit("problem reading the video file")


def make_cropped_video(filename, x, y, width, height, output_name):
    print 'ffmpeg -i {} -filter:v "crop={}:{}:{}:{}" {}'.format(filename, width, height, x, y, output_name)
    subprocess.call(
        'ffmpeg -i {} -filter:v "crop={}:{}:{}:{}" {}'.format(
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

    w = abs(x_end - ix)
    h = abs(y_end - iy)
    print "width: {}\nheight: {}".format(w, h)
    
    # come up with a new output name
    name = video_name.split('.')[0] + "_cropped." + video_name.split('.')[1]
    
    # have ffmpeg crop the video
    try:
        make_cropped_video(video_name, ix, iy, w, h, name)
    except:
        sys.exit("problem with subprocess call to ffmpeg")

    # open the new cropped video right away
    open_cropped_video(name)

    # fin
