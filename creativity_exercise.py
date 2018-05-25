import requests, sys, datetime, os

import smtplib
from smtplib import SMTP_SSL
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from random import sample

def send_email(body):
    # based on https://gist.github.com/scottsweb/79fc6433c3f308ce1cd5

    msg = MIMEMultipart()
    msg['From'] = 'lukereding@gmail.com'
    msg['To'] = 'lukereding@gmail.com'
    msg['Subject'] = "creativity exercise"

    msg.attach(MIMEText(body))

    server = SMTP_SSL("smtp.gmail.com", 465)
    server.login('lukereding@gmail.com', os.getenv('gmail'))
    server.sendmail('lukereding@gmail.com', 'lukereding@gmail.com', msg.as_string())
    #server.quit()
    server.close()
    print("Email sent")


def make_email_body(words):
    body = """Construct a story, sentence, or paragraph the contain the following three words: {}
    """.format(", ".join(words))
    return body

def get_common_words():
    res = requests.get("https://gist.githubusercontent.com/deekayen/4148741/raw/01c6252ccc5b5fb307c1bb899c95989a8a284616/1-1000.txt")
    if res.ok != True:
        sys.exit("There was a problem downloading the most common words.")
    else:
        # the first 150ish words are fairly boring (e.g. "and")
        return res.text.split("\n")[150:]

if __name__ == "__main__":

    words = get_common_words()

    sampled_words = sample(words, 3)

    email_body = make_email_body(sampled_words)

    send_email(email_body)
