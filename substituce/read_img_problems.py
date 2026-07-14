#! /usr/bin/python
# -*- coding: utf-8 -*-

import csv
import os
import time
import sys
import hashlib
from datetime import datetime, timedelta

limit=500
# csvsoubor='csv/problem_txt_un.csv'
csvsoubor='csv/problem_img.csv'

# subarea=str(sys.argv[1])
# if subarea=="":
#     subarea="50"

id=0

with open(csvsoubor, 'r', encoding='utf-8') as csvfile:
    spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    for row in spamreader:
        # if row['state']!='qa':
        #     continue;
        if ";" in row['question_en'] + row['question_es']:
            print (row['project_id'])
            id = id+1


sys.exit()

