import re
import subprocess
from datetime import datetime
from os.path import expanduser
import time
import os

from random import sample

import smtplib
from smtplib import SMTP_SSL
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# issues:
## includes the end of the previous receipe

def send_email(body):
    # based on https://gist.github.com/scottsweb/79fc6433c3f308ce1cd5

    msg = MIMEMultipart()
    msg['From'] = 'lukereding@gmail.com'
    msg['To'] = 'lukereding@gmail.com'
    x = datetime.now()
    date = x.strftime('%d %b %Y')
    msg['Subject'] = date + ": Python recipe of the day"

    msg.attach(MIMEText(body))

    server = SMTP_SSL("smtp.gmail.com", 465)
    server.login('lukereding@gmail.com', os.getenv('gmail'))
    server.sendmail('lukereding@gmail.com', 'lukereding@gmail.com', msg.as_string())
    #server.quit()
    server.close()
    print("Email sent")


def bash_command(cmd):
    x = subprocess.Popen(['/bin/bash', '-c', cmd])
    time.sleep(1)

def get_start_pages(file):
    # only used initially to extract the start pages for the recipes from the table of contents

    regex = r'^[0-9]+$'

    start_pages = []

    with open(file, 'r') as f:
        lines = f.readlines()
        for line in lines:
            if re.match(regex, line):
                # page 1 in the book is page 19 of the pdf
                start_pages = start_pages + [int(line.strip()) + 18]

    end_pages = start_pages[1:]
    # we don't know when the last recipe ends
    # guess 5 pages
    end_pages.extend([end_pages[len(end_pages)-1]])
    end_pages[len(end_pages)-1] = int(end_pages[len(end_pages)-1]) + 5

    return list(zip(start_pages, end_pages))

def get_plaintext(pdf, start, stop):
    output_file = expanduser("~") + "/Downloads/out.txt"
    command = "pdftotext -f {start} -l {stop} -nopgbrk -layout {pdf} {file}".format(start = start, stop = stop, pdf = pdf, file = output_file)

    print("command: {}".format(command))

    bash_command(command)

    # read in output file
    result = ""
    with open(output_file) as f:
        for line in f.readlines():
            result += line
    return result

recipe_start_stops = [(19, 21),
 (21, 23),
 (23, 25),
 (25, 26),
 (26, 29),
 (29, 30),
 (30, 31),
 (31, 33),
 (33, 35),
 (35, 36),
 (36, 38),
 (38, 39),
 (39, 41),
 (41, 42),
 (42, 44),
 (44, 46),
 (46, 47),
 (47, 50),
 (50, 51),
 (51, 55),
 (55, 56),
 (56, 58),
 (58, 60),
 (60, 63),
 (63, 64),
 (64, 65),
 (65, 66),
 (66, 68),
 (68, 70),
 (70, 71),
 (71, 72),
 (72, 75),
 (75, 76),
 (76, 79),
 (79, 82),
 (82, 83),
 (83, 84),
 (84, 87),
 (87, 96),
 (96, 101),
 (101, 102),
 (102, 105),
 (105, 107),
 (107, 108),
 (108, 110),
 (110, 112),
 (112, 114),
 (114, 115),
 (115, 118),
 (118, 120),
 (120, 122),
 (122, 124),
 (124, 125),
 (125, 127),
 (127, 128),
 (128, 131),
 (131, 132),
 (132, 133),
 (133, 135),
 (135, 137),
 (137, 138),
 (138, 140),
 (140, 141),
 (141, 143),
 (143, 145),
 (145, 147),
 (147, 149),
 (149, 150),
 (150, 153),
 (153, 154),
 (154, 156),
 (156, 159),
 (159, 162),
 (162, 162),
 (162, 163),
 (163, 165),
 (165, 166),
 (166, 167),
 (167, 169),
 (169, 170),
 (170, 171),
 (171, 174),
 (174, 175),
 (175, 176),
 (176, 178),
 (178, 179),
 (179, 181),
 (181, 183),
 (183, 184),
 (184, 185),
 (185, 188),
 (188, 189),
 (189, 193),
 (193, 197),
 (197, 201),
 (201, 204),
 (204, 207),
 (207, 209),
 (209, 211),
 (211, 213),
 (213, 215),
 (215, 217),
 (217, 217),
 (217, 221),
 (221, 232),
 (232, 235),
 (235, 237),
 (237, 238),
 (238, 239),
 (239, 240),
 (240, 242),
 (242, 243),
 (243, 245),
 (245, 249),
 (249, 250),
 (250, 253),
 (253, 256),
 (256, 261),
 (261, 263),
 (263, 264),
 (264, 266),
 (266, 268),
 (268, 269),
 (269, 274),
 (274, 278),
 (278, 282),
 (282, 285),
 (285, 288),
 (288, 292),
 (292, 295),
 (295, 301),
 (301, 305),
 (305, 309),
 (309, 311),
 (311, 312),
 (312, 317),
 (317, 323),
 (323, 324),
 (324, 329),
 (329, 335),
 (335, 339),
 (339, 341),
 (341, 347),
 (347, 349),
 (349, 351),
 (351, 352),
 (352, 354),
 (354, 357),
 (357, 359),
 (359, 363),
 (363, 365),
 (365, 368),
 (368, 370),
 (370, 373),
 (373, 374),
 (374, 377),
 (377, 380),
 (380, 382),
 (382, 385),
 (385, 388),
 (388, 392),
 (392, 394),
 (394, 400),
 (400, 402),
 (402, 404),
 (404, 406),
 (406, 410),
 (410, 415),
 (415, 416),
 (416, 417),
 (417, 419),
 (419, 422),
 (422, 424),
 (424, 425),
 (425, 426),
 (426, 427),
 (427, 429),
 (429, 430),
 (430, 446),
 (446, 449),
 (449, 450),
 (450, 451),
 (451, 455),
 (455, 459),
 (459, 463),
 (463, 465),
 (465, 467),
 (467, 472),
 (472, 474),
 (474, 476),
 (476, 479),
 (479, 482),
 (482, 488),
 (488, 493),
 (493, 499),
 (499, 503),
 (503, 506),
 (506, 509),
 (509, 515),
 (515, 518),
 (518, 522),
 (522, 523),
 (523, 527),
 (527, 531),
 (531, 534),
 (534, 538),
 (538, 542),
 (542, 549),
 (549, 552),
 (552, 557),
 (557, 558),
 (558, 559),
 (559, 562),
 (562, 563),
 (563, 563),
 (563, 565),
 (565, 567),
 (567, 568),
 (568, 570),
 (570, 573),
 (573, 576),
 (576, 577),
 (577, 579),
 (579, 581),
 (581, 583),
 (583, 585),
 (585, 588),
 (588, 590),
 (590, 591),
 (591, 592),
 (592, 594),
 (594, 596),
 (596, 598),
 (598, 600),
 (600, 601),
 (601, 603),
 (603, 605),
 (605, 608),
 (608, 617),
 (617, 623),
 (623, 627),
 (627, 630),
 (630, 632),
 (632, 637),
 (637, 643),
 (643, 643),
 (643, 645),
 (645, 650),
 (650, 656),
 (656, 661),
 (661, 662),
 (662, 666),
 (666, 671),
 (671, 672),
 (672, 675),
 (675, 676),
 (676, 677),
 (677, 680),
 (680, 681),
 (681, 686)]

if __name__ == "__main__":

    home = expanduser("~")

    pdf = home + "/Downloads/Python_Cookbook_3rd_Edition.pdf"

    # choose a recipe at random
    recipe = sample(recipe_start_stops, 1)

    text = get_plaintext(pdf, start = recipe[0][0], stop = recipe[0][1])

    send_email(text)
