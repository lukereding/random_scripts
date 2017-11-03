import numpy as np
from scipy.misc import imread
import matplotlib.pyplot as plt
import sys

photo = imread(sys.argv[1])

chan = {0 : "red",
    1: "green",
    2: "blue"}

h, w, _ = photo.shape

plt.figure(figsize = (10, 4))

# split r g and b

for i, channel in enumerate(np.dsplit(photo, 3)):
    x = np.linspace(1, w, w)
    y = np.linspace(1, h, h)

    X, Y = np.meshgrid(x, y)

    plt.subplot(1, 3, i+1)
    plt.contourf(X, Y, channel.reshape(h, w), cmap = "inferno")
    plt.axis('equal')
    plt.title(" {} channel".format(chan[i]))

plt.savefig("split_channels.jpg")
