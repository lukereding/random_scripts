import re
import subprocess
from datetime import datetime
from os.path import expanduser

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
    _ = x.wait()

def get_start_pages(file):
    # only used initially to extract the start pages for the recipes from the table of contents

    regex = r'^[0-9]+$'

    start_pages = []

    with open(file, 'r') as f:
        lines = f.readlines()
        for line in lines:
            if re.match(regex, line):
                # pdb.set_trace()
                start_pages = start_pages + [int(line.strip())]

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

recipe_start_stops = [(1, 3),
 (3, 5),
 (5, 7),
 (7, 8),
 (8, 11),
 (11, 12),
 (12, 13),
 (13, 15),
 (15, 17),
 (17, 18),
 (18, 20),
 (20, 21),
 (21, 23),
 (23, 24),
 (24, 26),
 (26, 28),
 (28, 29),
 (29, 32),
 (32, 33),
 (33, 37),
 (37, 38),
 (38, 40),
 (40, 42),
 (42, 45),
 (45, 46),
 (46, 47),
 (47, 48),
 (48, 50),
 (50, 52),
 (52, 53),
 (53, 54),
 (54, 57),
 (57, 58),
 (58, 61),
 (61, 64),
 (64, 65),
 (65, 66),
 (66, 69),
 (69, 78),
 (78, 83),
 (83, 84),
 (84, 87),
 (87, 89),
 (89, 90),
 (90, 92),
 (92, 94),
 (94, 96),
 (96, 97),
 (97, 100),
 (100, 102),
 (102, 104),
 (104, 106),
 (106, 107),
 (107, 109),
 (109, 110),
 (110, 113),
 (113, 114),
 (114, 115),
 (115, 117),
 (117, 119),
 (119, 120),
 (120, 122),
 (122, 123),
 (123, 125),
 (125, 127),
 (127, 129),
 (129, 131),
 (131, 132),
 (132, 135),
 (135, 136),
 (136, 138),
 (138, 141),
 (141, 144),
 (144, 144),
 (144, 145),
 (145, 147),
 (147, 148),
 (148, 149),
 (149, 151),
 (151, 152),
 (152, 153),
 (153, 156),
 (156, 157),
 (157, 158),
 (158, 160),
 (160, 161),
 (161, 163),
 (163, 165),
 (165, 166),
 (166, 167),
 (167, 170),
 (170, 171),
 (171, 175),
 (175, 179),
 (179, 183),
 (183, 186),
 (186, 189),
 (189, 191),
 (191, 193),
 (193, 195),
 (195, 197),
 (197, 199),
 (199, 199),
 (199, 203),
 (203, 214),
 (214, 217),
 (217, 219),
 (219, 220),
 (220, 221),
 (221, 222),
 (222, 224),
 (224, 225),
 (225, 227),
 (227, 231),
 (231, 232),
 (232, 235),
 (235, 238),
 (238, 243),
 (243, 245),
 (245, 246),
 (246, 248),
 (248, 250),
 (250, 251),
 (251, 256),
 (256, 260),
 (260, 264),
 (264, 267),
 (267, 270),
 (270, 274),
 (274, 277),
 (277, 283),
 (283, 287),
 (287, 291),
 (291, 293),
 (293, 294),
 (294, 299),
 (299, 305),
 (305, 306),
 (306, 311),
 (311, 317),
 (317, 321),
 (321, 323),
 (323, 329),
 (329, 331),
 (331, 333),
 (333, 334),
 (334, 336),
 (336, 339),
 (339, 341),
 (341, 345),
 (345, 347),
 (347, 350),
 (350, 352),
 (352, 355),
 (355, 356),
 (356, 359),
 (359, 362),
 (362, 364),
 (364, 367),
 (367, 370),
 (370, 374),
 (374, 376),
 (376, 382),
 (382, 384),
 (384, 386),
 (386, 388),
 (388, 392),
 (392, 397),
 (397, 398),
 (398, 399),
 (399, 401),
 (401, 404),
 (404, 406),
 (406, 407),
 (407, 408),
 (408, 409),
 (409, 411),
 (411, 412),
 (412, 428),
 (428, 431),
 (431, 432),
 (432, 433),
 (433, 437),
 (437, 441),
 (441, 445),
 (445, 447),
 (447, 449),
 (449, 454),
 (454, 456),
 (456, 458),
 (458, 461),
 (461, 464),
 (464, 470),
 (470, 475),
 (475, 481),
 (481, 485),
 (485, 488),
 (488, 491),
 (491, 497),
 (497, 500),
 (500, 504),
 (504, 505),
 (505, 509),
 (509, 513),
 (513, 516),
 (516, 520),
 (520, 524),
 (524, 531),
 (531, 534),
 (534, 539),
 (539, 540),
 (540, 541),
 (541, 544),
 (544, 545),
 (545, 545),
 (545, 547),
 (547, 549),
 (549, 550),
 (550, 552),
 (552, 555),
 (555, 558),
 (558, 559),
 (559, 561),
 (561, 563),
 (563, 565),
 (565, 567),
 (567, 570),
 (570, 572),
 (572, 573),
 (573, 574),
 (574, 576),
 (576, 578),
 (578, 580),
 (580, 582),
 (582, 583),
 (583, 585),
 (585, 587),
 (587, 590),
 (590, 599),
 (599, 605),
 (605, 609),
 (609, 612),
 (612, 614),
 (614, 619),
 (619, 625),
 (625, 625),
 (625, 627),
 (627, 632),
 (632, 638),
 (638, 643),
 (643, 644),
 (644, 648),
 (648, 653),
 (653, 654),
 (654, 657),
 (657, 658),
 (658, 659),
 (659, 662),
 (662, 663),
 (663, 668)]

if __name__ == "__main__":

    home = expanduser("~")

    pdf = home + "/Downloads/Python_Cookbook_3rd_Edition.pdf"

    # choose a recipe at random
    recipe = sample(recipe_start_stops, 1)

    text = get_plaintext(pdf, start = recipe[0][0], stop = recipe[0][1])

    send_email(text)
    
