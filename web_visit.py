#!/usr/bin/env python

from fake_useragent import UserAgent
import requests
import time
from random import uniform

'''

run using

docker run -it -v $(pwd):/opt mmast/scrapy-tor python web_visit.py

'''

ua = UserAgent()

url = 'http://journals.plos.org/plosntds/article?id=10.1371/journal.pntd.0001969'
url = "https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1008125"

i = 0

while True:

    header = {'User-Agent' : ua.random}

    print("header: {}\niteration: {}".format(header, i))

    response = requests.get(url, headers=header)

    i += 1

    sleep_sec = int(uniform(5,75))
    time.sleep(sleep_sec)

print("done")
