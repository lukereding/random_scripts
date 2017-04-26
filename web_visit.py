from fake_useragent import UserAgent
import requests
import numpy as np
import time

'''

run using

docker run -it -v $(pwd):/opt mmast/scrapy-tor python web_visit.py

'''

ua = UserAgent()

url = 'http://journals.plos.org/plosntds/article?id=10.1371/journal.pntd.0001969'

i = 0

while i < 200:

    header = {'User-Agent' : ua.random}

    print("header: {}\niteration: {}".format(header, i))

    response = requests.get(url, headers=header)

    i += 1

    sleep_sec = int(np.random.randint(30,100,1))
    time.sleep(sleep_sec)

print("done")
