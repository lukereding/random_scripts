import numpy as np
from matplotlib import pyplot as plt
from skimage import io, segmentation as seg, color
import argparse

'''

based on http://melvincabatuan.github.io/SCIKIT-Segmentation/

usage: python k_means_color.py -i image.jpg

'''
def mean_color(image, labels):
    out = np.zeros_like(image)
    for label in np.unique(labels):
        indices = np.nonzero(labels == label)
        out[indices] = np.mean(image[indices], axis=0)
    return out

# construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", required = True, help = "Path to the image")
ap.add_argument("-n", "--number_segments", required = False, help = "number of segments", default = 100)
args = vars(ap.parse_args())

image = io.imread(args["image"])
labels = seg.slic(image, n_segments=args["number_segments"])
io.imsave('out.jpg', mean_color(image, labels))