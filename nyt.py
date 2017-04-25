#!/usr/bin/env python3

'''
Opens the top three stories for the nytimes as separate tabs in your browser.
'''

import requests, webbrowser, bs4

## to do
### use argpasse and add a -n flag

print('searching...')
res = requests.get('https://www.nytimes.com/')

try:
    res.raise_for_status()
except Exception as e:
    print("there was a problem fetching the site: {}".format(e))

soup = bs4.BeautifulSoup(res.text, "html5lib")

links = soup.select('.story-heading a')

print("number of links on page: {}".format(len(links)))

for i in range(3):
    webbrowser.open(links[i].get('href'))
